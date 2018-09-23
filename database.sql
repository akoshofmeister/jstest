SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `firstname` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `lastname` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `zip` varchar(4) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `city` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `street` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `number` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `phone` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci ROW_FORMAT=COMPACT;

CREATE TABLE `order_products` (
  `id` int(11) NOT NULL,
  `orderId` int(11) NOT NULL,
  `productId` int(11) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

CREATE TABLE `products` (
  `id` int(11) NOT NULL,
  `category` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `name` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL,
  `price` int(11) NOT NULL,
  `spicy` tinyint(1) NOT NULL,
  `vegetarian` tinyint(1) NOT NULL,
  `description` varchar(255) COLLATE utf8mb4_hungarian_ci NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_hungarian_ci;

INSERT INTO `products` (`id`, `category`, `name`, `price`, `spicy`, `vegetarian`, `description`) VALUES
(1, 'Starter', 'Cézár saláta', 700, 0, 0, 'Saláta csirkemellel, uborkával, pirított kenyérkockával'),
(2, 'Starter', 'Coleslaw', 500, 0, 0, 'Amerikai káposztasaláta'),
(3, 'Starter', 'Tócsni', 750, 0, 1, 'Tökmag pestoval'),
(4, 'Soup', 'Húsleves', 800, 0, 0, 'Csigatésztával vagy májgaluskával'),
(5, 'Soup', 'Bableves', 1000, 0, 0, 'Tejfölös csülkös'),
(6, 'Soup', 'Gyümölcsleves', 1000, 0, 1, 'Tejszínhabbal, erdei gyümölcsökkel'),
(7, 'Soup', 'Halászlé', 1500, 1, 0, 'Pontyból, harcsából és busából'),
(8, 'MainDish', 'Pacalpörkölt', 1200, 0, 1, 'Törtburgonyával'),
(9, 'MainDish', 'Pacalpörkölt', 1200, 0, 0, 'Törtburgonyával'),
(10, 'MainDish', 'Bécsi szelet', 2500, 0, 0, ''),
(11, 'MainDish', 'Rántott cukkini', 1500, 0, 1, 'Rizzsel, vagy hasábburgonyával'),
(12, 'MainDish', 'Marhapörkölt', 2500, 0, 1, 'Galuskával'),
(13, 'Pizza', 'Pizza Margherita', 1000, 0, 1, 'Paradicsomszósz, bazsalikom'),
(14, 'Pizza', 'Pizza Tonno', 1500, 0, 0, 'Tonhalas, paradicsomos, mozzarellás'),
(15, 'Pizza', 'Pizza Quattro Formaggi', 2000, 0, 1, 'Négyféle sajttal'),
(16, 'Pizza', 'Húsimádó Pizza', 2000, 1, 0, 'Sonkával, pikáns szalámival, füstölt kolbásszal'),
(17, 'Dessert', 'Somlói galuska', 1000, 0, 0, ''),
(18, 'Drink', 'Coca-Cola', 300, 0, 0, ''),
(19, 'Drink', 'Ásványvíz', 300, 0, 0, ''),
(20, 'Drink', 'Házi limonádé', 650, 0, 0, ''),
(21, 'Drink', 'Red Bull', 700, 0, 0, '');

ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `order_products`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `products`
  ADD PRIMARY KEY (`id`);

ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `order_products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

ALTER TABLE `products`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
