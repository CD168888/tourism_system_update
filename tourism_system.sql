-- MySQL dump 10.13  Distrib 8.0.34, for Win64 (x86_64)
--
-- Host: 127.0.0.1    Database: tourism_system
-- ------------------------------------------------------
-- Server version	8.0.34

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `accommodation`
--

DROP TABLE IF EXISTS `accommodation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accommodation` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '酒店/民宿/客栈等',
  `address` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL,
  `scenic_id` bigint DEFAULT NULL COMMENT '关联景点ID',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `contact_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `price_range` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '价格区间',
  `star_level` decimal(2,1) DEFAULT NULL COMMENT '评分',
  `image_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  `features` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '特色服务',
  `distance` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '距景点距离',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `scenic_id` (`scenic_id`) USING BTREE,
  CONSTRAINT `accommodation_ibfk_1` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spot` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accommodation`
--

LOCK TABLES `accommodation` WRITE;
/*!40000 ALTER TABLE `accommodation` DISABLE KEYS */;
INSERT INTO `accommodation` VALUES (28,'小鸟天堂民宿','民宿','江门市新会区会城街道天马村小鸟天堂景区旁',8,'紧邻小鸟天堂景区，推窗可见榕林水景，提供特色陈皮宴，可预约鹭鸟观赏讲解服务。','0750-6789012','200-400元/晚',4.8,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/6afdf086-59e8-459f-b5ed-23be3b74667c.jpg','近景区入口，步行5分钟','约0.5公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(29,'新会碧桂园凤凰酒店','酒店','江门市新会区会城街道启超大道9号',8,'轻奢商务酒店，配备泳池、自助早餐，距小鸟天堂车程10分钟，适合家庭出游。','0750-6668888','400-800元/晚',4.5,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/065be60f-fb75-444f-94df-7108c2ea125b.jpg','免费停车、亲子设施、会议室','约3公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(30,'那琴半岛酒店','度假酒店','江门市台山市北陡镇那琴半岛景区内',9,'景区内临海酒店，客房带观海阳台，步行直达栈道和沙滩，含双人景区门票。','0750-5788888','800-1500元/晚',4.9,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/32e12ab2-c752-4781-952d-600bab955b5a.jpg','海景房、沙滩接送、海鲜餐厅','景区内，步行3分钟','2025-11-30 22:53:40','2025-11-30 22:53:40'),(31,'北陡镇渔家民宿','民宿','江门市台山市北陡镇那琴村',9,'本地渔民改造的民宿，提供出海捕鱼体验，距景区车程8分钟，性价比高。','0750-5781234','150-300元/晚',4.6,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/3af443e5-3484-4874-bb03-83f464f28608.jpg','渔家菜、洗衣服务、行李寄存','约4公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(32,'圭峰山庄','度假山庄','江门市新会区会城街道圭峰山风景区内',10,'藏于圭峰山森林中的山庄，中式庭院风格，清晨可登山看日出，提供山泉茶点。','0750-6188888','300-600元/晚',4.7,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/1e4fb25f-7713-4111-9fe7-943e531c3cf1.jpg','登山步道直达、茶室、素食餐厅','景区内，步行10分钟至玉台寺','2025-11-30 22:53:40','2025-11-30 22:53:40'),(33,'新会龙泉度假酒店','酒店','江门市新会区会城街道圭峰路龙泉坑',10,'依山傍水的园林式酒店，有温泉泡池、水上乐园，距圭峰山正门车程5分钟。','0750-6177777','500-1000元/晚',4.8,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/adc0ae8e-a7b0-4efa-94c4-bc9bd8c11437.jpg','温泉、亲子乐园、湖景房','约2公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(34,'自力村民居客栈','客栈','江门市开平市塘口镇自力村碉楼群内',11,'由百年碉楼改造的客栈，保留华侨建筑特色，可体验碉楼夜游、稻田摄影指导。','0750-2678888','300-500元/晚',4.9,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/4d72d11e-6bc4-496b-b4d0-9533bca4b7c8.jpg','碉楼特色房、早餐送到房、摄影服务','景区内，步行2分钟','2025-11-30 22:53:40','2025-11-30 22:53:40'),(35,'开平潭江半岛酒店','酒店','江门市开平市长沙街道潭江中路11号',11,'开平市区高端酒店，江景房视野开阔，距自力村车程20分钟，配套中餐厅和KTV。','0750-2228888','400-700元/晚',4.6,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/70b76294-8072-4bbc-b30f-bbc78f33a5c2.jpg','江景房、宴会厅、免费洗衣','约15公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(36,'赤坎古镇骑楼民宿','民宿','江门市开平市赤坎镇古镇景区内',12,'百年骑楼改造的民宿，民国风装修，推窗即古镇街景，含古镇夜游门票。','0750-2612345','400-800元/晚',4.8,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/16e8b8a6-a7f8-465d-9664-e00ec443dd58.jpg','民国风体验、旗袍租赁、特色小吃','景区内，步行1分钟','2025-11-30 22:53:40','2025-11-30 22:53:40'),(37,'赤坎大酒店','酒店','江门市开平市赤坎镇中华西路1号',12,'紧邻古镇入口，现代简约风格，停车方便，适合商务和家庭游客，提供古镇导览服务。','0750-2618888','200-400元/晚',4.5,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/468b563e-dbdb-4fa1-843d-934a34c1c9b2.jpg','免费停车、旅游咨询、叫醒服务','约0.8公里','2025-11-30 22:53:40','2025-11-30 22:53:40'),(38,'古劳水乡民宿','民宿','江门市鹤山市古劳镇水乡景区内',14,'临水而建的水乡民宿，船坞式设计，可乘乌篷船直达房间，提供水乡特色腊味饭。','0750-8788888','300-600元/晚',4.9,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/6f42139c-29cf-4103-b09b-f66578a62b3a.jpg','临水房、乌篷船体验、农家菜','景区内，步行5分钟至摩天轮','2025-11-30 22:53:40','2025-11-30 22:53:40'),(39,'鹤山方圆福朋喜来登酒店','酒店','江门市鹤山市沙坪街道鹤山大道623号',14,'国际连锁品牌酒店，设施齐全，距古劳水乡车程15分钟，适合商务和亲子出行。','0750-8888888','500-900元/晚',4.7,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/e0b21e8a-dffd-461f-8eb0-c01af32fa647.jpg','泳池、健身房、儿童乐园','约8公里','2025-11-30 22:53:40','2025-11-30 22:53:40');
/*!40000 ALTER TABLE `accommodation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `accommodation_review`
--

DROP TABLE IF EXISTS `accommodation_review`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `accommodation_review` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `user_id` bigint DEFAULT NULL,
  `accommodation_id` bigint DEFAULT NULL,
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `rating` decimal(2,1) DEFAULT NULL,
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `accommodation_id` (`accommodation_id`) USING BTREE,
  CONSTRAINT `accommodation_review_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `accommodation_review_ibfk_2` FOREIGN KEY (`accommodation_id`) REFERENCES `accommodation` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `accommodation_review`
--

LOCK TABLES `accommodation_review` WRITE;
/*!40000 ALTER TABLE `accommodation_review` DISABLE KEYS */;
/*!40000 ALTER TABLE `accommodation_review` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `carousel`
--

DROP TABLE IF EXISTS `carousel`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `carousel` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `title` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '轮播图标题',
  `image_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '轮播图片地址',
  `status` tinyint DEFAULT '1' COMMENT '状态: 1-启用, 0-禁用',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `carousel`
--

LOCK TABLES `carousel` WRITE;
/*!40000 ALTER TABLE `carousel` DISABLE KEYS */;
INSERT INTO `carousel` VALUES (1,'美丽山水','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/e20a32da-1b9a-40b0-a717-9e601eedab0f.jpeg',1,'2025-05-30 22:25:21','2025-05-30 22:25:21'),(2,'古城风貌','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/1cd44324-8b34-43bf-8f86-66b850be8fa3.jpeg',1,'2025-05-30 22:25:21','2025-05-30 22:25:21'),(3,'海滨度假','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/38a4aa61-37ce-48d2-9372-5768aee65088.jpeg',1,'2025-05-30 22:25:21','2025-05-30 22:25:21'),(4,'民俗文化','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/1c298172-3f7f-4e4b-95c4-e8d1971ff5e9.jpg',1,'2025-05-30 22:25:21','2025-05-30 22:25:21'),(5,'城市夜景','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/ca6393eb-0b8a-4d62-bf3a-08b8d95abd63.jpg',0,'2025-05-30 22:25:21','2025-05-30 22:33:40');
/*!40000 ALTER TABLE `carousel` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_message`
--

DROP TABLE IF EXISTS `chat_message`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_message` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '消息ID',
  `session_id` bigint NOT NULL COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `message_type` tinyint(1) NOT NULL COMMENT '消息类型(0:AI消息, 1:用户消息)',
  `content` text NOT NULL COMMENT '消息内容',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`),
  KEY `idx_session_id` (`session_id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_create_time` (`create_time`)
) ENGINE=InnoDB AUTO_INCREMENT=37 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI聊天消息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_message`
--

LOCK TABLES `chat_message` WRITE;
/*!40000 ALTER TABLE `chat_message` DISABLE KEYS */;
INSERT INTO `chat_message` VALUES (31,23,9,1,'推荐一些适合周末游玩的景点','2025-11-30 21:44:32'),(32,23,9,0,'当然可以！以下是一些适合周末游玩的景点推荐，涵盖自然风光、历史文化、休闲度假等不同类型，适合不同兴趣和出行距离的选择：\n\n🌿 自然风光类（适合放松身心、亲近自然）  \n1. **杭州西湖**（浙江杭州）  \n   - 湖光山色，四季皆美，可骑行、泛舟、漫步苏堤白堤，周边还有灵隐寺、龙井村等景点。  \n2. **张家界国家森林公园**（湖南张家界）  \n   - 奇峰林立，云雾缭绕，适合徒步和摄影，电影《阿凡达》取景地之一。  \n3. **桂林阳朔**（广西桂林）  \n   - 漓江泛舟、遇龙河竹筏、十里画廊骑行，山水如画，非常适合短途度假。  \n\n🏯 历史文化类（适合喜欢人文与古迹）  \n4. **平遥古城**（山西晋中）  \n   - 保存完好的明清古城，感受古代票号文化和晋商历史，夜晚灯光也很美。  \n5. **乌镇/西塘**（浙江嘉兴）  \n   - 典型江南水乡，小桥流水人家，适合慢节奏游览，体验古镇夜景与茶馆文化。  \n6. **西安城墙 & 大唐不夜城**（陕西西安）  \n   - 骑行古城墙，打卡兵马俑，晚上在大唐不夜城感受盛唐风情。  \n\n🏕️ 休闲度假类（适合家庭或情侣出游）  \n7. **莫干山**（浙江湖州）  \n   - 山间民宿林立，空气清新，适合避暑、泡温泉、品茶、发呆。  \n8. **厦门鼓浪屿**（福建厦门）  \n   - 文艺小岛，有老建筑、咖啡馆、海边栈道，适合悠闲漫步拍照。  \n9. **长白山**（吉林延边）  \n   - 天池美景、森林徒步、温泉体验，冬季还可滑雪，四季皆宜。  \n\n🚗 近郊短途类（适合1-2小时车程）  \n10. **北京香山公园 or 奥森公园**（北京）  \n    - 秋天赏红叶，春天踏青，适合城市居民周末放松。  \n11. **上海崇明岛**  \n    - 生态农场、湿地公园、骑行露营，远离喧嚣的好去处。  \n12. **广州从化温泉小镇**  \n    - 泡温泉、摘水果、逛古村落，适合亲子或家庭出游。\n\n📌 小贴士：  \n- 出行前查看天气和景区预约政策。  \n- 周末游客较多，建议错峰或提前购票。  \n- 可结合当地美食一起体验，让旅程更丰富！\n\n如果你告诉我所在城市或偏好（如喜欢爬山、看海、逛古镇等），我可以为你定制更精准的推荐哦！😊','2025-11-30 21:44:55'),(33,24,9,1,'制定一个三日游的旅行计划','2025-12-01 00:02:35'),(34,24,9,0,'您好！我是江门市旅游推荐官，很高兴为您服务～  \n为了给您制定一份**清晰、可执行的三日游计划**，我需要先了解一些基本信息：\n\n请您补充以下信息，以便我精准推荐：\n1. **出行日期**（是否节假日？影响人流与住宿价格）\n2. **出行天数**：您说“三日游”，是连续3天吗？如第1天下午到、第3天晚上走？\n3. **出发地**（例如广州、深圳、香港？决定交通方式和时间）\n4. **预算范围**（人均/总预算？经济型、舒适型还是高端？）\n5. **同行人数及构成**（如：2大1小、老人是否同行？影响行程节奏）\n6. **兴趣偏好**（更喜欢：侨乡文化 / 自然风光 / 美食打卡 / 拍照出片 / 亲子活动？）\n\n📌 举个例子：  \n> “我们一家四口（2大2小，孩子7岁和10岁），从广州出发，打算下周末（6月14-16日）去江门玩3天2晚，预算人均800元，喜欢拍照、吃小吃、轻松不赶路。”\n\n👉 您提供得越详细，我给的行程就越贴合实际、好操作！\n\n期待您的回复～ 😊','2025-12-01 00:02:54'),(35,24,9,1,'我们一家四口（2大2小，孩子7岁和10岁），从广州出发，打算下周末（6月14-16日）去江门玩3天2晚，预算人均800元，喜欢拍照、吃小吃、轻松不赶路','2025-12-01 00:03:08'),(36,24,9,0,'您好！欢迎选择江门作为您的周末亲子短途目的地～  \n根据您提供的信息，我已为您量身定制一份**适合家庭出游、节奏轻松、兼顾拍照与美食的三日游计划**。请看详细推荐：\n\n---\n\n### 🌟 概览  \n江门是“中国侨都”，拥有独特的骑楼老街、田园风光和地道广府美食。本次行程以**开平碉楼+赤坎古镇+长堤风貌街**为核心，融合亲子互动与慢节奏体验，特别适合带娃家庭边走边拍、边玩边吃，三天不赶路，人均可控在800元内。\n\n---\n\n### 🗓 推荐行程（2024年6月14日-16日｜3天2晚）\n\n#### **第1天（6月14日，周五）｜广州 → 江门市区 → 赤坎古镇**\n| 时间段 | 景点 | 停留时长 | 交通方式 | 建议活动 |\n|--------|------|----------|---------|----------|\n| 14:00-15:30 | 广州南站 → 开平南站 | 约1.5小时 | 高铁（推荐D字头） | 建议买14:00左右车次，孩子可在车上小憩 |\n| 15:30-16:00 | 开平南站 → 赤坎古镇 | 15分钟 | 打车/网约车 | 提前约好接站司机更省心 |\n| 16:00-18:30 | 赤坎古镇（免门票区域） | 2.5小时 | 步行 | 漫步潭江边骑楼街，打卡复古邮局、电影拍摄点；推荐穿浅色衣服拍照超美📸 |\n| 18:30-19:30 | 晚餐：赤坎本地小吃 | 1小时 | 步行 | 必尝：豆腐角、煲仔饭、古井烧鹅小份（孩子爱吃） |\n| 19:30-20:00 | 返回酒店 | 15分钟 | 打车 | 入住赤坎或塘口镇特色民宿 |\n\n> ✅ 小贴士：第一天不安排太满，让孩子适应环境；赤坎古镇目前部分开放，但免费区域足够逛足。\n\n---\n\n#### **第2天（6月15日，周六）｜开平碉楼深度游 + 自然野趣**\n| 时间段 | 景点 | 停留时长 | 交通方式 | 建议活动 |\n|--------|------|----------|---------|----------|\n| 09:00-09:30 | 酒店 → 自力村景区 | 30分钟 | 租车自驾 / 包车（推荐） | 若无车建议提前预约包车服务（约300元/天） |\n| 09:30-11:30 | 自力村碉楼群（门票¥78） | 2小时 | 步行+电瓶车 | 参观铭石楼、云幻楼等经典碉楼，孩子们可“寻宝式”找窗花图案 |\n| 11:30-12:30 | 午餐：塘口镇农家菜 | 1小时 | 打车/步行 | 推荐：塘口空间餐厅（环境好，有儿童椅） |\n| 12:30-14:00 | 立园景区（门票¥100） | 1.5小时 | 步行 | 中西合璧园林，适合拍全家福；有凉亭可休息 |\n| 14:30-16:00 | 燕子窝营地 or 四眼井公园（二选一） | 1-1.5小时 | 打车 | - 推荐度⭐⭐⭐⭐☆：燕子窝营地（户外草坪+滑梯+咖啡车，孩子放电首选）<br>- 备选：四眼井公园（安静纳凉，近市区） |\n| 18:00-19:00 | 晚餐：赤坎古镇新食街 | 1小时 | 打车 | 尝试黄鳝饭、陈皮红豆沙（清凉解暑） |\n\n> ✅ 小贴士：立园有轮椅通道，老人也可轻松游览；自力村可租借讲解器（¥20），提升文化体验。\n\n---\n\n#### **第3天（6月16日，周日）｜江门市区文化漫步 + 返程**\n| 时间段 | 景点 | 停留时长 | 交通方式 | 建议活动 |\n|--------|------|----------|---------|----------|\n| 09:00-10:30 | 酒店 → 江门市区（蓬江区） | 约1.5小时 | 自驾/高铁（开平南→江门站） | 若坐高铁建议买10:00前班次 |\n| 10:30-12:00 | 长堤风貌街 & 新宁火车站旧址 | 1.5小时 | 步行 | 拍摄百年骑楼、复古火车头；孩子可参与“侨乡明信片”DIY |\n| 12:00-13:00 | 午餐：常安路步行街小吃 | 1小时 | 步行 | 必吃：外海面、钵仔糕、陈皮饼（可作手信） |\n| 13:00-14:00 | 仁寿路老洋楼书吧 or 五邑华侨广场 | 1小时 | 步行 | - 文艺家庭推荐：仁寿路“社活局”书吧（安静看书喝咖啡）<br>- 想吹空调可去华侨广场商场歇脚 |\n| 14:30-16:00 | 江门站 → 广州南站 | 约1.5小时 | 高铁 | 建议买14:30-15:00之间车次，预留缓冲时间 |\n\n> ✅ 小贴士：最后一天节奏缓，方便返程途中孩子休息；可顺路在江门站买真空包装的陈皮花生当伴手礼。\n\n---\n\n### 🚆 交通建议\n\n| 出行段 | 方式 | 说明 |\n|--------|------|------|\n| **广州 → 江门** | 高铁为主 | - 推荐路线：广州南站 ⇄ 开平南站（最快58分钟，二等座¥78）<br>- 或到“江门站”再转公交/打车至赤坎（稍绕路） |\n| **市内交通** | 包车/租车优先 | - 家庭出行强烈建议**包车一日游**（约¥300-350/天，含司机等候）<br>- 若自驾：从广州出发约2小时，赤坎/塘口均有停车场（免费） |\n| **替代方案** | 公交+打车组合 | - 公交可达性一般，景点分散，带娃不推荐全程公交 |\n\n> 🔔 温馨提示：节假日高铁票紧张，请**立即登录12306购票**（尤其周五下午、周日下午返程）！\n\n---\n\n### 🍜 美食推荐（亲子友好·本地人常去）\n\n| 美食 | 推荐店铺 | 地址/位置 | 推荐理由 |\n|------|----------|-----------|----------|\n| **赤坎豆腐角** | 老伍豆腐角 | 赤坎古镇影视街入口旁 | 外脆里嫩，微辣不呛，孩子也能吃 |\n| **古井烧鹅** | 恒益烧鹅（总店） | 新会区古井镇 | 可打包半只（约¥80），皮香肉嫩，配酸梅酱 |\n| **黄鳝饭** | 赤坎供销饭店 | 赤坎古镇内 | 用柴火煲制，鲜香浓郁，分小份装 |\n| **外海面** | 大排档风味馆 | 江门市长安路 | “竹升面”手工压制，汤清味鲜，适合早餐 |\n| **陈皮茶点** | 社活局·仁寿路店 | 蓬江区仁寿路 | 陈皮红豆沙、陈皮绿豆饼，清热解腻，适合夏天 |\n\n> 💡 小众彩蛋：在“塘口空间”可品尝**碉楼下午茶套餐**（含陈皮果冻、糯米鸡），环境文艺又接地气。\n\n---\n\n### 💰 费用估算（按一家四口｜总预算约 ¥3,200｜人均 ¥800）\n\n| 项目 | 明细说明 | 预估费用（总额） |\n|------|----------|------------------|\n| **交通** | 往返高铁票（广州南↔开平南）x4 = ¥624；市内包车2天≈¥650 | ¥1,274 |\n| **住宿** | 2晚赤坎/塘口特色民宿（家庭房/两间房）≈¥380/晚 | ¥760 |\n| **门票** | 自力村¥78×4=¥312；立园¥100×4=¥400；其他免费 | ¥712 |\n| **餐饮** | 正餐5顿 × ¥80/人 + 小吃零食 ≈ ¥1,600 | ¥1,600 |\n| **总计** | —— | **约 ¥3,200–3,500** |\n\n> ✅ 控预算技巧：\n> - 提前网购联票（如“开平碉楼+立园”套票略便宜）\n> - 午晚餐各一正餐+小吃补充，避免景区高价餐厅\n> - 选择免费景点为主，核心收费景区精选1-2个深度游\n\n---\n\n### ⚠ 注意事项与小贴士\n\n🌡 **气候提醒**：  \n6月中旬江门已入夏，平均气温28-34℃，多阵雨。请备好：\n- 防晒用品（遮阳帽、防晒霜、太阳镜）\n- 折叠伞或轻便雨衣\n- 驱蚊液（乡村地区蚊虫较多）\n\n👕 **穿衣建议**：  \n- 轻薄透气衣物为主，搭配一件薄外套（室内空调较冷）\n- 孩子建议穿舒适运动鞋（需步行较多）\n\n👵 **老人小孩关怀**：  \n- 行程每日安排午休时间，避免高温时段外出\n- 景区基本有厕所、休息亭，立园、赤坎有无障碍通道\n- 可携带便携小风扇、湿巾、儿童零食\n\n📌 **其他提示**：\n- 所有门票价格以现场为准，建议通过“**开平文旅**”微信公众号提前购票\n- 不建议自行进入未开发碉楼或野塘游泳，安全第一\n- 陈皮为当地特产，正规店购买更保真（认准“新会陈皮”地理标志）\n\n---\n\n如有需要，我也可以为您提供：\n✅ 可打印版PDF行程单  \n✅ 景点导航链接合集  \n✅ 高铁购票指引截图模板  \n欢迎继续提问，祝您一家在江门度过一个愉快又难忘的周末！🌿📷🍜','2025-12-01 00:04:00');
/*!40000 ALTER TABLE `chat_message` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `chat_session`
--

DROP TABLE IF EXISTS `chat_session`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `chat_session` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '会话ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `session_name` varchar(255) NOT NULL COMMENT '会话名称',
  `create_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`),
  KEY `idx_user_id` (`user_id`),
  KEY `idx_update_time` (`update_time`)
) ENGINE=InnoDB AUTO_INCREMENT=25 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci COMMENT='AI聊天会话表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `chat_session`
--

LOCK TABLES `chat_session` WRITE;
/*!40000 ALTER TABLE `chat_session` DISABLE KEYS */;
INSERT INTO `chat_session` VALUES (23,9,'周末出游推荐','2025-11-30 21:44:30','2025-11-30 21:44:57'),(24,9,'江门三日游计划','2025-12-01 00:02:33','2025-12-01 00:03:08');
/*!40000 ALTER TABLE `chat_session` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collection`
--

DROP TABLE IF EXISTS `collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `collection` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `guide_id` bigint DEFAULT NULL COMMENT '攻略ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `guide_id` (`guide_id`) USING BTREE,
  CONSTRAINT `collection_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `collection_ibfk_2` FOREIGN KEY (`guide_id`) REFERENCES `travel_guide` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=20 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collection`
--

LOCK TABLES `collection` WRITE;
/*!40000 ALTER TABLE `collection` DISABLE KEYS */;
INSERT INTO `collection` VALUES (3,3,1,'2025-05-14 14:02:00'),(5,4,1,'2025-05-14 14:04:00'),(6,4,2,'2025-05-14 14:05:00'),(13,2,4,'2025-05-31 02:12:48'),(14,6,8,'2025-06-19 21:55:57'),(16,3,3,'2025-08-03 12:35:04'),(17,3,4,'2025-08-03 17:21:40'),(19,9,11,'2025-11-24 00:03:39');
/*!40000 ALTER TABLE `collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment`
--

DROP TABLE IF EXISTS `comment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '评论ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `scenic_id` bigint DEFAULT NULL COMMENT '景点ID',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '评论内容',
  `rating` int DEFAULT NULL COMMENT '评分(1-5)',
  `likes` int DEFAULT '0' COMMENT '点赞数',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `scenic_id` (`scenic_id`) USING BTREE,
  CONSTRAINT `comment_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comment_ibfk_2` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spot` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='评论表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment`
--

LOCK TABLES `comment` WRITE;
/*!40000 ALTER TABLE `comment` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `comment_like`
--

DROP TABLE IF EXISTS `comment_like`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `comment_like` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '点赞ID',
  `user_id` bigint DEFAULT NULL COMMENT '用户ID',
  `comment_id` bigint DEFAULT NULL COMMENT '评论ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_comment` (`user_id`,`comment_id`) USING BTREE,
  KEY `comment_id` (`comment_id`) USING BTREE,
  CONSTRAINT `comment_like_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `comment_like_ibfk_2` FOREIGN KEY (`comment_id`) REFERENCES `comment` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='评论点赞关系表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `comment_like`
--

LOCK TABLES `comment_like` WRITE;
/*!40000 ALTER TABLE `comment_like` DISABLE KEYS */;
/*!40000 ALTER TABLE `comment_like` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scenic_category`
--

DROP TABLE IF EXISTS `scenic_category`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scenic_category` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '分类ID',
  `name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '分类名称',
  `description` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类描述',
  `icon` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '分类图标',
  `parent_id` bigint DEFAULT '0' COMMENT '父分类ID，0表示一级分类',
  `sort_order` int DEFAULT '0' COMMENT '排序序号',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='景点分类表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scenic_category`
--

LOCK TABLES `scenic_category` WRITE;
/*!40000 ALTER TABLE `scenic_category` DISABLE KEYS */;
INSERT INTO `scenic_category` VALUES (1,'自然风光','包括山水、湖泊、瀑布等自然景观','/img/category/nature.png',0,1,'2025-05-29 15:31:47','2025-05-29 15:31:47'),(2,'历史文化','包括古迹、博物馆、历史遗址等','/img/category/history.png',0,2,'2025-05-29 15:31:47','2025-05-29 15:31:47'),(3,'主题公园','各类主题乐园、游乐场等','/img/category/theme.png',0,3,'2025-05-29 15:31:47','2025-05-29 15:31:47'),(4,'城市地标','城市中的标志性建筑和景点','/img/category/landmark.png',0,4,'2025-05-29 15:31:47','2025-05-29 15:31:47'),(5,'乡村民俗','乡村风光、民俗文化体验地','/img/category/rural.png',0,5,'2025-05-29 15:31:47','2025-05-29 15:31:47');
/*!40000 ALTER TABLE `scenic_category` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scenic_collection`
--

DROP TABLE IF EXISTS `scenic_collection`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scenic_collection` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '收藏ID',
  `user_id` bigint NOT NULL COMMENT '用户ID',
  `scenic_id` bigint NOT NULL COMMENT '景点ID',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_user_scenic` (`user_id`,`scenic_id`) USING BTREE,
  KEY `idx_user_id` (`user_id`) USING BTREE,
  KEY `idx_scenic_id` (`scenic_id`) USING BTREE,
  CONSTRAINT `scenic_collection_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `scenic_collection_ibfk_2` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spot` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='景点收藏表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scenic_collection`
--

LOCK TABLES `scenic_collection` WRITE;
/*!40000 ALTER TABLE `scenic_collection` DISABLE KEYS */;
/*!40000 ALTER TABLE `scenic_collection` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `scenic_spot`
--

DROP TABLE IF EXISTS `scenic_spot`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `scenic_spot` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '景点ID',
  `name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '景点名称',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '景点描述',
  `location` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '地理位置',
  `price` decimal(10,2) DEFAULT NULL COMMENT '票价',
  `opening_hours` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '开放时间',
  `image_url` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '图片URL',
  `longitude` decimal(10,6) DEFAULT NULL COMMENT '经度',
  `latitude` decimal(10,6) DEFAULT NULL COMMENT '纬度',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `category_id` bigint DEFAULT NULL COMMENT '分类ID',
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=18 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='景点信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `scenic_spot`
--

LOCK TABLES `scenic_spot` WRITE;
/*!40000 ALTER TABLE `scenic_spot` DISABLE KEYS */;
INSERT INTO `scenic_spot` VALUES (8,'小鸟天堂','巴金散文里的 “独木成林” 奇观！390 年古榕覆盖水面，上万只鹭鸟早晚归巢，乘船游河能近距离看百鸟齐飞～','江门市新会区会城街道天马村',50.00,'08:00-17:30','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/6d3b4f97-d0fc-419f-aa02-69b4b9db3148.jpg',113.052000,22.598000,'2025-11-30 22:23:53','2025-11-30 22:52:01',1),(9,'那琴半岛地质海洋公园','环山观海木栈桥上能同时看碧蓝大海和奇形怪石（比如 “震海神狮”），沙滩平缓，适合踏浪 + 拍海景大片。','江门市台山市北陡镇那琴半岛',98.00,'08:00-18:00','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/daf74a7f-b19a-4120-ace5-cecbb196b780.jpg',112.189000,21.927000,'2025-11-30 22:26:18','2025-11-30 22:52:01',1),(10,'圭峰山国家森林公园','森林覆盖率 98% 的 “城市氧吧”，春季有樱花栈道，山顶玉台寺古意悠悠，还能俯瞰新会城区。','江门市新会区会城街道圭峰路',0.00,'07:00-18:00','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/5fd9f977-1d4f-402b-a99f-c4ab16fc3606.jpg',113.008000,22.587000,'2025-11-30 22:27:52','2025-11-30 22:52:01',1),(11,'开平碉楼文化旅游区（自力村）','世界文化遗产！稻田里错落着 15 座中西合璧的碉楼，11 月稻浪金黄时拍照超出片，能听碉楼背后的华侨故事。','江门市开平市塘口镇自力村',78.00,'08:30-17:30','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/ac73d0d1-a7e6-4696-b242-9d393cdf731c.jpg',112.615000,22.208000,'2025-11-30 22:30:37','2025-11-30 22:52:01',2),(12,'赤坎华侨古镇','680 多座百年骑楼连成复古街区，《让子弹飞》同款场景，随便拍都是民国风大片，晚上灯光亮起更有氛围～','江门市开平市赤坎镇',120.00,'10:00-22:00','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/4cd71bb8-f107-4a12-b180-e4cf1052e19f.jpg',112.578000,22.227000,'2025-11-30 22:31:53','2025-11-30 22:52:01',2),(13,'长堤历史文化街区','《狂飙》取景地！中西合璧的骑楼里藏着老江门的烟火气，适合慢悠悠逛吃 + 打卡 “明星同款”。','江门市蓬江区长堤风貌街',0.00,'全天开放','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/9b595ed4-bf9a-4ec4-b1df-bc6fea64fb41.jpg',113.073000,22.580000,'2025-11-30 22:34:20','2025-11-30 22:52:01',2),(14,'古劳水乡旅游区','升级后的 “广东威尼斯”！不仅有乡村游船，还新增了 88 米摩天轮、过山车等游乐设施，亲子游超合适。','江门市鹤山市古劳镇',120.00,'09:00-18:00','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/2aece011-530d-471a-ae12-b506aa8bbb14.jpg',112.925000,22.765000,'2025-11-30 22:35:28','2025-11-30 22:52:01',3),(15,'西江之眼摩天轮','江门第一座巨型摩天轮（80 米高）！360° 俯瞰西江、大雁山和九江大桥，VIP 轿厢还有沙发座椅，日落时观景绝了～','江门市鹤山市沙坪街道滨江路',68.00,'10:00-22:00','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/6d94e9fc-4abc-469b-85ef-9c47b14031dc.jpg',112.948000,22.687000,'2025-11-30 22:37:02','2025-11-30 22:52:01',4),(16,'江门船厂','复古文艺新地标！50 年代老船厂改造的创意聚集地，老船坞、旧车间里藏着咖啡馆和文创店，适合拍工业风照片。','江门市江海区船厂路',0.00,'全天开放（商户营业时间不同）','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/a5c054bd-7e70-42e8-9d76-0999868c2322.jpg',113.062000,22.570000,'2025-11-30 22:38:48','2025-11-30 22:52:01',4),(17,'鹤城客家花炮庙会','省级非遗民俗！每年正月到三月有烧炮、醒狮、客家山歌表演，全村摆围餐的热闹场面超有氛围感～','江门市鹤山市鹤城镇',0.00,'每年正月至三月期间举办','https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/a1676d99-e17a-43e7-903b-addc89454163.jpg',112.856000,22.723000,'2025-11-30 22:40:10','2025-11-30 22:52:01',5);
/*!40000 ALTER TABLE `scenic_spot` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket`
--

DROP TABLE IF EXISTS `ticket`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `scenic_id` bigint NOT NULL,
  `ticket_name` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '门票名称',
  `price` decimal(10,2) NOT NULL,
  `discount_price` decimal(10,2) DEFAULT NULL COMMENT '优惠价格',
  `ticket_type` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '门票类型(成人票/儿童票/学生票等)',
  `valid_period` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '有效期',
  `description` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci,
  `stock` int DEFAULT NULL COMMENT '剩余数量',
  `status` tinyint DEFAULT '1' COMMENT '状态: 1-可预订, 0-不可预订',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `scenic_id` (`scenic_id`) USING BTREE,
  CONSTRAINT `ticket_ibfk_1` FOREIGN KEY (`scenic_id`) REFERENCES `scenic_spot` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=19 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket`
--

LOCK TABLES `ticket` WRITE;
/*!40000 ALTER TABLE `ticket` DISABLE KEYS */;
INSERT INTO `ticket` VALUES (16,8,'小鸟天堂-成人票',50.00,NULL,'成人票','购买后30日内有效','巴金散文里的 “独木成林” 奇观！390 年古榕覆盖水面，上万只鹭鸟早晚归巢，乘船游河能近距离看百鸟齐飞～',999,1,'2025-11-30 22:42:32','2025-11-30 22:42:32'),(17,8,'小鸟天堂-儿童票',50.00,0.01,'儿童票','购买后30日内有效','巴金散文里的 “独木成林” 奇观！390 年古榕覆盖水面，上万只鹭鸟早晚归巢，乘船游河能近距离看百鸟齐飞～',999,1,'2025-11-30 22:43:09','2025-11-30 22:45:16'),(18,8,'小鸟天堂-学生票',50.00,25.00,'学生票','购买后30日内有效','巴金散文里的 “独木成林” 奇观！390 年古榕覆盖水面，上万只鹭鸟早晚归巢，乘船游河能近距离看百鸟齐飞～',0,1,'2025-11-30 22:43:45','2025-11-30 22:44:44');
/*!40000 ALTER TABLE `ticket` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `ticket_order`
--

DROP TABLE IF EXISTS `ticket_order`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `ticket_order` (
  `id` bigint NOT NULL AUTO_INCREMENT,
  `order_no` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '订单编号',
  `user_id` bigint NOT NULL,
  `ticket_id` bigint NOT NULL,
  `quantity` int NOT NULL COMMENT '购买数量',
  `visitor_name` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '游客姓名',
  `visitor_phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '游客手机号',
  `id_card` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '身份证号',
  `visit_date` date NOT NULL COMMENT '游玩日期',
  `total_amount` decimal(10,2) NOT NULL COMMENT '订单总金额',
  `status` tinyint DEFAULT '0' COMMENT '0-待支付, 1-已支付, 2-已取消, 3-已退款, 4-已完成',
  `payment_time` datetime DEFAULT NULL COMMENT '支付时间',
  `payment_method` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '支付方式',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `update_time` datetime DEFAULT NULL ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  KEY `ticket_id` (`ticket_id`) USING BTREE,
  CONSTRAINT `ticket_order_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ticket_order_ibfk_2` FOREIGN KEY (`ticket_id`) REFERENCES `ticket` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=57 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `ticket_order`
--

LOCK TABLES `ticket_order` WRITE;
/*!40000 ALTER TABLE `ticket_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `ticket_order` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `travel_guide`
--

DROP TABLE IF EXISTS `travel_guide`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `travel_guide` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '攻略ID',
  `title` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '标题',
  `content` text CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci COMMENT '内容',
  `user_id` bigint DEFAULT NULL COMMENT '作者ID',
  `cover_image` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '封面图片',
  `views` int DEFAULT '0' COMMENT '浏览量',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`id`) USING BTREE,
  KEY `user_id` (`user_id`) USING BTREE,
  CONSTRAINT `travel_guide_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `user` (`id`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB AUTO_INCREMENT=12 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='旅游攻略表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `travel_guide`
--

LOCK TABLES `travel_guide` WRITE;
/*!40000 ALTER TABLE `travel_guide` DISABLE KEYS */;
INSERT INTO `travel_guide` VALUES (1,'江门一日游经典路线攻略','<div style=\'padding:10px;\'><h3 style=\'color:#E63946;\'>🌿 行程概览：小鸟天堂 → 圭峰山国家森林公园 → 长堤历史文化街区</h3><hr/><p><strong>✅ 上午：小鸟天堂生态探秘</strong>📍 地址：江门市新会区会城街道天马村🎫 门票：50 元 / 人（含游船）⏰ 游玩时长：1.5 小时推荐体验：<ul><li>清晨 6:30-8:00 乘船，近距离观赏上万鹭鸟归巢的震撼场景</li><li>打卡巴金《鸟的天堂》散文同款取景地，390 年古榕树 “独木成林” 奇观</li></ul><img src=\'https://placeholder.com/birds-paradise\' alt=\'小鸟天堂鹭鸟群飞\' style=\'width:100%;max-width:600px;border-radius:8px;margin:10px 0;\'/></p><p><strong>🍜 中午：新会特色美食打卡</strong>推荐餐厅：<em>小鸟天堂周边 “陈皮人家”</em>必点菜品：陈皮鸭、古井烧鹅、凉瓜炒牛肉</p><p><strong>🌲 下午：圭峰山氧吧漫步</strong>📍 地址：江门市新会区会城街道圭峰路🎫 门票：免费亮点：<ul><li>春季（3-4 月）樱花栈道浪漫绽放，拍照超出片</li><li>登顶玉台寺俯瞰新会城区全景，古寺香火旺盛</li></ul></p><p><strong>🌃 晚上：长堤历史文化街区夜游</strong>📍 地址：江门市蓬江区长堤风貌街特色体验：<ul><li>打卡《狂飙》同款 “旧厂街” 取景地，拍复古港风大片</li><li>逛吃街头小吃：猪肠碌（5 元 / 份）、咖喱鱼蛋（8 元 / 份）、钵仔糕（3 元 / 个）</li><li>启明里文创街区灯光夜景超美，适合散步打卡</li></ul></div>',2,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/065be60f-fb75-444f-94df-7108c2ea125b.jpg',1275,'2025-05-14 13:00:00','2025-11-30 23:57:39'),(2,'江门侨乡文化两日游攻略','<div style=\'padding:10px;\'><h3 style=\'color:#264653;\'>🏯 行程概览：Day1 开平碉楼 + 赤坎古镇 | Day2 茶坑村 + 长堤街区</h3><hr/><h4 style=\'color:#2A9D8F;\'>📅 Day1：世界遗产碉楼与百年古镇之旅</h4><p><strong>🌾 上午：自力村碉楼群探秘</strong>📍 地址：江门市开平市塘口镇自力村🎫 门票：78 元 / 人⏰ 开放时间：08:30-17:30深度体验：<ul><li>11 月稻浪金黄时，碉楼与稻田相映成画，摄影绝佳</li><li>参观铭石楼、云幻楼，听导游讲述华侨 “下南洋” 的奋斗故事</li><li>碉楼内保留民国时期家具，沉浸式感受侨乡生活</li></ul><img src=\'https://placeholder.com/kailuan-tower\' alt=\'开平碉楼稻田风光\' style=\'width:100%;max-width:600px;border-radius:8px;margin:10px 0;\'/></p><p><strong>🍲 中午：塘口农家乐美食</strong>必吃：台山黄鳝饭（38 元 / 煲）、赤坎豆腐角（10 元 / 份）、马冈鹅肉</p><p><strong>🏮 下午 - 晚上：赤坎华侨古镇沉浸式体验</strong>📍 地址：江门市开平市赤坎镇🎫 门票：120 元 / 人（含夜游）推荐玩法：<ul><li>租赁民国旗袍 / 长衫（50 元 / 小时），在 680 座骑楼间拍复古大片</li><li>夜游古镇，灯光映照下的骑楼群宛如电影场景</li><li>入住古镇内骑楼民宿（400-800 元 / 晚），推窗即街景</li></ul></p><h4 style=\'color:#2A9D8F;\'>📅 Day2：非遗陈皮与城市烟火之旅</h4><p><strong>🍊 上午：茶坑村陈皮文化体验</strong>📍 地址：江门市新会区会城街道茶坑村亮点：<ul><li>参观梁启超故居（门票 10 元 / 人），了解国学大师生平</li><li>体验国家级非遗 “新会陈皮制作”，亲手晒陈皮</li><li>陈皮村选购正宗三年陈陈皮（80-200 元 / 斤）</li></ul></p><p><strong>🚶 下午：长堤历史文化街区逛吃</strong>打卡点：水埠头、三十三墟街、《狂飙》猪脚面同款店铺</p></div>',3,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/32e12ab2-c752-4781-952d-600bab955b5a.jpg',998,'2025-05-14 13:01:00','2025-12-01 00:02:04'),(3,'江门亲子游专属攻略','<div style=\'padding:10px;\'><h3 style=\'color:#F4A261;\'>👨👩👧👦 行程概览：古劳水乡 → 西江之眼摩天轮 → 江海长廊生态园</h3><hr/><p><strong>🎡 上午：古劳水乡童趣之旅</strong>📍 地址：江门市鹤山市古劳镇🎫 门票：120 元 / 人（含游乐项目）亲子必玩：<ul><li>乘乌篷船穿行水巷，听船夫讲水乡故事（1.2 米以下儿童免票）</li><li>挑战 88 米高 “水乡之眼” 摩天轮，俯瞰万亩鱼塘</li><li>亲子过山车、旋转木马等游乐设施，孩子超爱</li></ul><img src=\'https://placeholder.com/gulao-water-town\' alt=\'古劳水乡摩天轮\' style=\'width:100%;max-width:600px;border-radius:8px;margin:10px 0;\'/></p><p><strong>🍱 中午：水乡特色美食</strong>推荐：水乡腊味饭（25 元 / 份）、疍家蒸鱼（48 元 / 条）、桑叶炒蛋</p><p><strong>🌅 下午：西江之眼摩天轮日落体验</strong>📍 地址：江门市鹤山市沙坪街道滨江路🎫 门票：68 元 / 人（VIP 轿厢 128 元 / 舱）亮点：<ul><li>VIP 轿厢带沙发座椅，适合家庭合影</li><li>17:30-18:30 乘坐，360° 观赏西江日落</li><li>周边滨江公园可放风筝、野餐</li></ul></p><p><strong>🌸 次日备选：江海长廊生态园</strong>📍 地址：江门市江海区礼乐街道礼东村🎫 门票：50 元 / 人玩法：<ul><li>萌宠喂养（羊驼、兔子、小鹿）</li><li>秋冬季节采摘番石榴、圣女果（按斤收费）</li><li>异木棉盛开时，粉色花海 + 红色摩天轮拍照绝美</li></ul></div>',4,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/3af443e5-3484-4874-bb03-83f464f28608.jpg',1108,'2025-05-14 13:02:00','2025-11-30 23:06:44'),(4,'江门自然风光休闲攻略','<div style=\'padding:10px;\'><h3 style=\'color:#2A9D8F;\'>🌊 行程概览：那琴半岛地质海洋公园 → 江门船厂文创园</h3><hr/><p><strong>🏖️ 上午：那琴半岛海岸探险</strong>📍 地址：江门市台山市北陡镇那琴半岛🎫 门票：98 元 / 人⏰ 开放时间：08:00-18:00必体验：<ul><li>沿 1000 米环山观海木栈道徒步，打卡 “震海神狮”“佛脚石” 等奇石</li><li>在婚纱摄影基地拍海景大片，蓝白建筑超出片</li><li>沙滩踏浪、捡贝壳，海水清澈适合亲子戏水</li></ul><img src=\'https://placeholder.com/naqin-peninsula\' alt=\'那琴半岛海岸线\' style=\'width:100%;max-width:600px;border-radius:8px;margin:10px 0;\'/></p><p><strong>🦞 中午：海鲜大餐</strong>推荐餐厅：<em>那琴半岛酒店海鲜餐厅</em>必点：清蒸石斑鱼、白灼虾、蒜蓉粉丝蒸扇贝</p><p><strong>🎨 下午：江门船厂文创园文艺打卡</strong>📍 地址：江门市江海区船厂路🎫 门票：免费玩法：<ul><li>50 年代老船坞、旧机床工业风拍照，秒出复古大片</li><li>打卡文创店：“船厂咖啡”（工业风装修，拿铁 28 元 / 杯）</li><li>逛艺术展览（不定期举办），感受老船厂的新生</li></ul><p style=\'color:#6C757D;\'>✨ 贴士：傍晚时分，夕阳洒在旧船坞上，光影效果最佳</p></div>',2,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/1e4fb25f-7713-4111-9fe7-943e531c3cf1.jpg',895,'2025-05-14 13:03:00','2025-11-30 23:57:36'),(8,'江门美食与住宿终极攻略','<div style=\'padding:10px;\'><h3 style=\'color:#E9C46A;\'>🍜 舌尖上的江门：必吃美食全攻略</h3><hr/><h4 style=\'color:#E63946;\'>🥇 招牌名菜</h4><ul><li><strong>古井烧鹅</strong>：推荐店铺：新会古井镇 “恒益烧腊”，选用乌鬃鹅，皮脆肉嫩，酸梅酱点睛（半只 88 元）</li><li><strong>新会陈皮宴</strong>：推荐 “陈皮村体验馆”，菜品：陈皮鸭、陈皮排骨、陈皮豆沙粽</li><li><strong>台山黄鳝饭</strong>：推荐开平 “黄鳝饭世家”，米饭粒粒分明，鳝肉鲜香（小煲 38 元）</li><li><strong>恩平濑粉</strong>：推荐恩平 “濑粉皇”，搭配牛腩汤底，爽滑弹牙（15 元 / 碗）</li></ul><img src=\'https://placeholder.com/jiangmen-food\' alt=\'江门特色美食\' style=\'width:100%;max-width:600px;border-radius:8px;margin:10px 0;\'/><h3 style=\'color:#264653;\'>🏨 住宿推荐：按需求选</h3><h4 style=\'color:#2A9D8F;\'>💎 高端型（500-1500 元 / 晚）</h4><ul><li><strong>那琴半岛酒店</strong>：景区内海景房，含双人门票，推窗见海</li><li><strong>新会龙泉度假酒店</strong>：园林式温泉酒店，适合家庭放松</li></ul><h4 style=\'color:#2A9D8F;\'>🏡 特色型（300-800 元 / 晚）</h4><ul><li><strong>赤坎古镇骑楼民宿</strong>：民国风装修，含夜游门票</li><li><strong>自力村民居客栈</strong>：碉楼改造，体验侨乡生活</li></ul><h4 style=\'color:#2A9D8F;\'>💰 经济型（150-300 元 / 晚）</h4><ul><li><strong>北陡镇渔家民宿</strong>：渔民改造，性价比高</li><li><strong>沙坪江畔民宿</strong>：近西江之眼，ins 风装修</li></ul><p style=\'background:#E8F4FD;padding:8px;border-radius:6px;margin-top:10px;\'><strong>💡 住宿贴士</strong>：节假日建议提前 1-2 周预订，碉楼 / 古镇内住宿需注意隔音哦～</p></div>',3,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/adc0ae8e-a7b0-4efa-94c4-bc9bd8c11437.jpg',7,'2025-05-31 02:10:05','2025-11-30 23:57:29'),(11,'测试标题','<h1>测试</h1><h2>二级</h2><h3>三级</h3><p><br></p><p>😏</p>',9,'https://sky-take-out-jcd.oss-cn-beijing.aliyuncs.com/4d72d11e-6bc4-496b-b4d0-9533bca4b7c8.jpg',16,'2025-11-23 00:29:58','2025-11-30 23:06:44');
/*!40000 ALTER TABLE `travel_guide` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `id` bigint NOT NULL AUTO_INCREMENT COMMENT '用户ID',
  `username` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '用户名',
  `password` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '密码(加密存储)',
  `nickname` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '昵称',
  `email` varchar(100) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci NOT NULL COMMENT '邮箱',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '手机号',
  `role_code` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT 'USER' COMMENT '角色code',
  `avatar` varchar(200) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '头像',
  `status` tinyint DEFAULT '1' COMMENT '状态(0:禁用,1:正常)',
  `create_time` datetime DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  `sex` varchar(10) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL COMMENT '性别',
  PRIMARY KEY (`id`) USING BTREE,
  UNIQUE KEY `uk_username` (`username`) USING BTREE,
  UNIQUE KEY `uk_email` (`email`) USING BTREE
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci ROW_FORMAT=DYNAMIC COMMENT='用户信息表';
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES (1,'admin','$2a$10$09F04vxwj85zvZcMP0ig6.HTglDVh4Wd/AqstoIu86SjGmhEAfJBu','管理员','admin@tourism.com','13800138000','ADMIN','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/a7ff93cf-e648-49ee-88b3-9ada8744eb6d.jpg',1,'2025-05-14 10:00:00','2025-11-27 22:33:49','女'),(2,'zhangsan','$2a$10$iul6jocLsH.A4gN1QUpgDexDq6KO89syHjUkRD3NbA1L6CTVrNRMO','张三','zhangsan@example.com','13712345678','USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-05-14 10:01:00','2025-11-30 21:54:33','男'),(3,'lisi','$2a$10$iul6jocLsH.A4gN1QUpgDexDq6KO89syHjUkRD3NbA1L6CTVrNRMO','李四','lisi@example.com','13812345679','USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-05-14 10:02:00','2025-11-30 21:54:33','女'),(4,'wangwu','$2a$10$iul6jocLsH.A4gN1QUpgDexDq6KO89syHjUkRD3NbA1L6CTVrNRMO','王五','wangwu@example.com','13912345670','USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-05-14 10:03:00','2025-11-30 21:54:33','男'),(6,'1796145608','$2a$10$7.DA4qkAKrtlaku9BBtcquqMbeH2dG4urusDoI3N1kAadKq7ttK5.',NULL,'1796145608@qq.com',NULL,'USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-06-19 21:11:58','2025-11-30 21:54:33',NULL),(8,'xiaodu','$2a$10$q0m3Czk2Sj0KP7Ddy/8zeekEowc7WZoQ4fn5VPyseeyRUE3Lqt9cK','小渡','2364728886@qq.com','','USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-11-23 00:06:28','2025-11-30 21:54:33',NULL),(9,'xiaoduya','$2a$10$8.zg.XKfdUmhfHtwkh7C/eCxU509kzkGyKIHfAEGiZyK2soWCiQeW','小渡吖','2364728888@qq.com','','USER','https://web-tlia1234.oss-cn-beijing.aliyuncs.com/ed6945f4-37dd-4f21-bb50-046b8ca78495.jpg',1,'2025-11-23 00:08:54','2025-11-27 23:03:58','男');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-12-01  0:04:32
