const express = require('express')
const mysql = require('mysql')
const app = express()
const port = 3000
const path = require('path');
const cors = require('cors')
const bodyParser = require('body-parser')

var pool = mysql.createPool({
	connectionLimit : 10,
	host : 'localhost',
	user : 'root',
	password : '',
	database : 'jstest'
  });

app.use(express.static('dist'))
app.use(cors())
app.use(bodyParser.json());  

var products = []

app.get('/products', (req, res) => {
	pool.getConnection((err, connection) => {
		if (err) throw err;

		connection.query('SELECT * FROM products', function (err, rows, fields) {
			connection.release()

			if (err) {
				res.status(500).send({
					type: 'error'
				})
				throw err
			}

			products = rows;
			res.send({ type: 'done', data: rows})
		})
	})
})

app.get('/stats', (req, res) => {
	pool.getConnection((err, connection) => {
		if (err) throw err;
  
		connection.query('SELECT productId, amount FROM order_products GROUP BY productId ORDER BY amount LIMIT 10', function (err, rows, fields) {
			connection.release()
			if (err) {
				res.status(500).send({
					type: 'error'
				})
				throw err
			}
		
			res.send({ type: 'done', data: rows})
		})
	})
})

app.post('/order', (req, res) => {
	if (
		!req.body.firstname ||
		!req.body.lastname ||
		!req.body.zip ||
		!req.body.city ||
		!req.body.number ||
		!req.body.street ||
		!req.body.phone ||
		!req.body.products ||
		!req.body.products.length
	) {
		res.status(500).send({type: 'Data error'});
	} else {
		pool.getConnection((err, connection) => {
			if (err) throw err;
			
			(new Promise((resolve, reject) => {
				if (!products.length) {
					connection.query('SELECT * FROM products', function (err, rows, fields) {
						if (!err) {
							products = rows;
							resolve()
						} else {
							reject()
						}
					}) 
				} else {
					resolve()
				}
			}))
				.then(() => {
					let prodIds = products.map(prod => prod.id)
					if (
						req.body.products.every(prod => prodIds.indexOf(prod.id) != -1)
					) {
						connection.query(
							'INSERT INTO orders (firstname, lastname, zip, city, number, street, phone) VALUES (?,?,?,?,?,?,?)', 
							[req.body.firstname, req.body.lastname, req.body.zip, req.body.city, req.body.number, req.body.street, req.body.phone],
							function (error, results) {
								if (error) throw error;
	
								let promises = []
	
								req.body.products.forEach(prod => {
									promises.push(new Promise((resolve, reject) => {
											connection.query(
												'INSERT INTO order_products (orderId, productId, amount) VALUE (?,?,?)', 
												[results.insertId, prod.id, prod.amount],
												function (error, results) {
													if (error) reject()
	
													resolve();
												}
											);
										})
									)
								})
	
								Promise.all(promises)
									.then(() => res.send({type: 'done'}))
									.catch((err) => {
										connection.release()
										res.status(500).send({type: 'error', data: 'Insert error'})
									})
							}
						);
					} else {
						connection.release()
						res.status(500).send({type: 'error', data: 'Wrong id'})
					}
				})
				.catch(err => {
					connection.release()
					res.status(500).send({type: 'error', data: 'Server error'});
				})
		})
	}
})

app.listen(port, () => console.log(`Running on ${port}`))