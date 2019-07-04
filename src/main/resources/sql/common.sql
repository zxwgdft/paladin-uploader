/*
Navicat MySQL Data Transfer

Source Server         : localhost_root
Source Server Version : 50624
Source Host           : localhost:3306
Source Database       : common

Target Server Type    : MYSQL
Target Server Version : 50624
File Encoding         : 65001

Date: 2019-06-10 10:39:02
*/

SET FOREIGN_KEY_CHECKS=0;

-- ----------------------------
-- Table structure for `db_build_column`
-- ----------------------------
DROP TABLE IF EXISTS `db_build_column`;
CREATE TABLE `db_build_column` (
  `id` varchar(32) COLLATE utf8_unicode_ci NOT NULL,
  `connection_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `table_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `column_name` varchar(100) COLLATE utf8_unicode_ci NOT NULL,
  `title` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL,
  `enum_code` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '常量CODE',
  `multi_select` tinyint(4) DEFAULT NULL COMMENT '是否多选',
  `is_attachment` tinyint(4) DEFAULT NULL COMMENT '是否附件',
  `attachment_count` int(11) DEFAULT NULL COMMENT '附件数量',
  `required` tinyint(4) DEFAULT NULL COMMENT '是否必填',
  `tableable` tinyint(4) DEFAULT NULL COMMENT '是否列表显示',
  `editable` tinyint(4) DEFAULT NULL COMMENT '是否可编辑',
  `addable` tinyint(4) DEFAULT NULL COMMENT '是否新增',
  `large_text` tinyint(4) DEFAULT NULL COMMENT '是否大文本',
  `max_length` int(11) DEFAULT NULL COMMENT '最大长度',
  `regular_expression` varchar(200) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '正则验证表达式',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;


-- ----------------------------
-- Table structure for `db_build_table`
-- ----------------------------
DROP TABLE IF EXISTS `db_build_table`;
CREATE TABLE `db_build_table` (
  `id` varchar(32) CHARACTER SET utf8 NOT NULL,
  `connection_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `table_name` varchar(100) CHARACTER SET utf8 NOT NULL,
  `table_title` varchar(100) CHARACTER SET utf8 NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;


-- ----------------------------
-- Table structure for `db_connection`
-- ----------------------------
DROP TABLE IF EXISTS `db_connection`;
CREATE TABLE `db_connection` (
  `name` varchar(100) NOT NULL,
  `url` varchar(400) NOT NULL,
  `type` varchar(30) NOT NULL,
  `user_name` varchar(50) NOT NULL,
  `password` varchar(50) DEFAULT NULL,
  `note` varchar(500) DEFAULT NULL,
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(32) DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_user_id` varchar(32) DEFAULT NULL COMMENT '更新人',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of db_connection
-- ----------------------------
INSERT INTO `db_connection` VALUES ('COMMON数据库', 'jdbc:mysql://172.16.11.135:3306/common?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai', 'MYSQL', 'root', '', '', '2019-02-28 11:00:45', 'cafa07da11744c26b8402a9a65ede744', '2019-04-15 14:35:45', 'ad313d38fe9447ce863fe8584743a010');

--------------------
-- Table structure for `org_permission`
-- ----------------------------
DROP TABLE IF EXISTS `org_permission`;
CREATE TABLE `org_permission` (
  `id` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT 'id',
  `name` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci NOT NULL COMMENT '权限名称',
  `url` varchar(200) DEFAULT NULL COMMENT '表现形式1：URL2：CODE',
  `code` varchar(200) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '表现内容',
  `is_menu` tinyint(4) DEFAULT NULL COMMENT '是否菜单',
  `menu_icon` varchar(50) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '图标',
  `description` varchar(500) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '权限描述',
  `parent_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '父ID',
  `is_admin` tinyint(4) DEFAULT NULL COMMENT '是否系统管理员权限',
  `list_order` int(11) DEFAULT '0' COMMENT '列表顺序',
  `grantable` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否可授予',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_user_id` varchar(32) CHARACTER SET utf8 COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更新人',
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of org_permission
-- ----------------------------
INSERT INTO `org_permission` VALUES ('1000', '系统管理', null, null, '1', null, null, null, '1', '0', '1', '2019-05-14 10:08:06', 'admin', '2019-05-14 10:08:09', 'admin', '0');
INSERT INTO `org_permission` VALUES ('1010', '角色管理', '/common/org/role/index', null, '1', '', null, '1000', '1', '99', '1', '2019-04-15 14:04:03', 'admin', '2019-04-15 14:04:00', 'admin', '0');
INSERT INTO `org_permission` VALUES ('2000', '样例', null, null, '1', null, null, null, '1', '1', '1', '2019-05-14 10:08:42', 'admin', '2019-05-14 10:08:48', 'admin', '0');
INSERT INTO `org_permission` VALUES ('2010', '人员管理', '/demo/demo/personnel/index', null, '1', null, null, '2000', '1', '1', '1', '2019-05-14 10:11:20', 'admin', '2019-05-14 10:11:23', 'admin', '0');
INSERT INTO `org_permission` VALUES ('2020', '机构管理', '/demo/demo/agency/index', null, '1', null, null, '2000', '1', '2', '1', '2019-05-14 10:12:04', 'admin', '2019-05-14 10:12:10', 'admin', '0');

-- ----------------------------
-- Table structure for `org_role`
-- ----------------------------
DROP TABLE IF EXISTS `org_role`;
CREATE TABLE `org_role` (
  `id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'id',
  `role_name` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '角色名称',
  `role_level` tinyint(4) NOT NULL COMMENT '角色等级（考核权限等级）',
  `role_desc` varchar(500) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '角色说明',
  `is_default` tinyint(4) NOT NULL DEFAULT '0' COMMENT '是否默认角色（1是0否）',
  `enable` tinyint(4) NOT NULL DEFAULT '1' COMMENT '是否启用 1是0否',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_user_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更新人',
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of org_role
-- ----------------------------
INSERT INTO `org_role` VALUES ('1', 'ADMIN', '0', '0', '0', '1', '2019-04-15 14:02:13', null, '2019-04-15 14:02:18', null, '0');

-- ----------------------------
-- Table structure for `org_role_permission`
-- ----------------------------
DROP TABLE IF EXISTS `org_role_permission`;
CREATE TABLE `org_role_permission` (
  `role_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '角色ID',
  `permission_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '菜单ID',
  PRIMARY KEY (`role_id`,`permission_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of org_role_permission
-- ----------------------------

-- ----------------------------
-- Table structure for `sys_attachment`
-- ----------------------------
DROP TABLE IF EXISTS `sys_attachment`;
CREATE TABLE `sys_attachment` (
  `id` varchar(32) NOT NULL,
  `use_type` tinyint(4) NOT NULL,
  `type` varchar(100) DEFAULT NULL,
  `name` varchar(100) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `size` int(11) unsigned DEFAULT NULL,
  `pelative_path` varchar(200) NOT NULL,
  `thumbnail_pelative_path` varchar(200) DEFAULT NULL COMMENT '缩略图相对地址',
  `create_time` datetime NOT NULL,
  PRIMARY KEY (`id`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=COMPACT;

-- ----------------------------
-- Records of sys_attachment
-- ----------------------------
INSERT INTO `sys_attachment` VALUES ('0a0f9ee0e1bf4ecf8fddb7df6e8be85c', '1', 'image/jpeg', '821cea8fc1dddaef592db77247828168', '.jpeg', '69807', '20190505/0a0f9ee0e1bf4ecf8fddb7df6e8be85c.jpeg', null, '2019-05-05 15:36:18');
INSERT INTO `sys_attachment` VALUES ('168179f58c2944e4b8c7463ef8c1118d', '1', 'image/jpeg', '262baa28d580d93328c6fb384c1afb55', '.jpeg', '205816', '20190505/168179f58c2944e4b8c7463ef8c1118d.jpeg', null, '2019-05-05 14:34:01');
INSERT INTO `sys_attachment` VALUES ('7069cdde99b045c9bbc3490fed12e689', '1', 'image/jpeg', 'b1180a7307b7a71fad3591947d5552cd', '.jpg', '135791', '20190505/7069cdde99b045c9bbc3490fed12e689.jpg', null, '2019-05-05 15:37:58');
INSERT INTO `sys_attachment` VALUES ('7167a212861a4cd2b30efa3ec48206ea', '1', 'image/jpeg', '0c6c8624b1f2b087bf76163e96c3cb9b', '.jpg', '403023', '20190505/7167a212861a4cd2b30efa3ec48206ea.jpg', null, '2019-05-05 15:34:42');
INSERT INTO `sys_attachment` VALUES ('864b0356e2d442c68a11cb5fac7389fa', '1', 'image/jpeg', '93d29a1f5ad17833dd98d99da7187b24', '.jpg', '249661', '20190505/864b0356e2d442c68a11cb5fac7389fa.jpg', null, '2019-05-05 15:33:07');
INSERT INTO `sys_attachment` VALUES ('8b73430068e74ac4b2cd93a50c31bda1', '1', 'image/jpeg', '262baa28d580d93328c6fb384c1afb55', '.jpeg', '205816', '20190505/8b73430068e74ac4b2cd93a50c31bda1.jpeg', null, '2019-05-05 14:32:07');
INSERT INTO `sys_attachment` VALUES ('fb5360a6aac34862abe85198c9c7f21e', '1', 'image/jpeg', '262baa28d580d93328c6fb384c1afb55', '.jpeg', '205816', '20190505/fb5360a6aac34862abe85198c9c7f21e.jpeg', null, '2019-05-05 14:36:08');

-- ----------------------------
-- Table structure for `sys_constant`
-- ----------------------------
DROP TABLE IF EXISTS `sys_constant`;
CREATE TABLE `sys_constant` (
  `type` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '分类',
  `code` varchar(11) COLLATE utf8_unicode_ci NOT NULL COMMENT '编码ID',
  `name` varchar(100) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '名称',
  `order_no` int(11) DEFAULT NULL COMMENT '排序号',
  PRIMARY KEY (`type`,`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_constant
-- ----------------------------
INSERT INTO `sys_constant` VALUES ('academic-degree-type', '1', '名誉博士', '1');
INSERT INTO `sys_constant` VALUES ('academic-degree-type', '2', '博士', '2');
INSERT INTO `sys_constant` VALUES ('academic-degree-type', '3', '硕士', '3');
INSERT INTO `sys_constant` VALUES ('academic-degree-type', '4', '学士', '4');
INSERT INTO `sys_constant` VALUES ('agency-type', '1', 'boolean\r\n', '1');
INSERT INTO `sys_constant` VALUES ('agency-type', '10', '医疗美容门诊部', '10');
INSERT INTO `sys_constant` VALUES ('agency-type', '11', '中医门诊部', '11');
INSERT INTO `sys_constant` VALUES ('agency-type', '12', '职业健康体检机构', '12');
INSERT INTO `sys_constant` VALUES ('agency-type', '13', '内科诊所', '13');
INSERT INTO `sys_constant` VALUES ('agency-type', '14', '外科诊所', '14');
INSERT INTO `sys_constant` VALUES ('agency-type', '15', '美容诊所', '15');
INSERT INTO `sys_constant` VALUES ('agency-type', '16', '口腔诊所', '16');
INSERT INTO `sys_constant` VALUES ('agency-type', '17', '中医诊所', '17');
INSERT INTO `sys_constant` VALUES ('agency-type', '18', '养老院', '18');
INSERT INTO `sys_constant` VALUES ('agency-type', '19', '卫生室', '19');
INSERT INTO `sys_constant` VALUES ('agency-type', '2', '二级医院', '2');
INSERT INTO `sys_constant` VALUES ('agency-type', '3', '一级医院', '3');
INSERT INTO `sys_constant` VALUES ('agency-type', '4', '社区卫生服务中心', '4');
INSERT INTO `sys_constant` VALUES ('agency-type', '5', '社区卫生服务站', '5');
INSERT INTO `sys_constant` VALUES ('agency-type', '6', '公共卫生单位', '6');
INSERT INTO `sys_constant` VALUES ('agency-type', '7', '民营医院', '7');
INSERT INTO `sys_constant` VALUES ('agency-type', '8', '门诊部', '8');
INSERT INTO `sys_constant` VALUES ('agency-type', '9', '口腔门诊部', '9');
INSERT INTO `sys_constant` VALUES ('boolean-type', '0', '否', '2');
INSERT INTO `sys_constant` VALUES ('boolean-type', '1', '是', '1');
INSERT INTO `sys_constant` VALUES ('dept-type', '1', '预防保健科', '1');
INSERT INTO `sys_constant` VALUES ('dept-type', '10', '内分泌', '10');
INSERT INTO `sys_constant` VALUES ('dept-type', '100', '肠道传染病', '100');
INSERT INTO `sys_constant` VALUES ('dept-type', '101', '呼吸道传染病', '101');
INSERT INTO `sys_constant` VALUES ('dept-type', '102', '肝炎', '102');
INSERT INTO `sys_constant` VALUES ('dept-type', '103', '虫媒传染病', '103');
INSERT INTO `sys_constant` VALUES ('dept-type', '104', '动物源性传染病', '104');
INSERT INTO `sys_constant` VALUES ('dept-type', '105', '蠕虫病', '105');
INSERT INTO `sys_constant` VALUES ('dept-type', '106', '其它', '106');
INSERT INTO `sys_constant` VALUES ('dept-type', '107', '结核病科', '107');
INSERT INTO `sys_constant` VALUES ('dept-type', '108', '地方病科', '108');
INSERT INTO `sys_constant` VALUES ('dept-type', '109', '肿瘤科', '109');
INSERT INTO `sys_constant` VALUES ('dept-type', '11', '免疫学', '11');
INSERT INTO `sys_constant` VALUES ('dept-type', '110', '急诊医学科', '110');
INSERT INTO `sys_constant` VALUES ('dept-type', '111', '康复医学科', '111');
INSERT INTO `sys_constant` VALUES ('dept-type', '112', '运动医学科', '112');
INSERT INTO `sys_constant` VALUES ('dept-type', '113', '职业病科', '113');
INSERT INTO `sys_constant` VALUES ('dept-type', '114', '职业中毒', '114');
INSERT INTO `sys_constant` VALUES ('dept-type', '115', '尘肺', '115');
INSERT INTO `sys_constant` VALUES ('dept-type', '116', '放射病', '116');
INSERT INTO `sys_constant` VALUES ('dept-type', '117', '物理因素损伤', '117');
INSERT INTO `sys_constant` VALUES ('dept-type', '118', '职业健康监护', '118');
INSERT INTO `sys_constant` VALUES ('dept-type', '119', '其他', '119');
INSERT INTO `sys_constant` VALUES ('dept-type', '12', '变态反应', '12');
INSERT INTO `sys_constant` VALUES ('dept-type', '120', '临终关怀科', '120');
INSERT INTO `sys_constant` VALUES ('dept-type', '121', '特种医学与军事医学科', '121');
INSERT INTO `sys_constant` VALUES ('dept-type', '122', '麻醉科', '122');
INSERT INTO `sys_constant` VALUES ('dept-type', '123', '疼痛科', '123');
INSERT INTO `sys_constant` VALUES ('dept-type', '124', '重症医学科', '124');
INSERT INTO `sys_constant` VALUES ('dept-type', '125', '医学检验科', '125');
INSERT INTO `sys_constant` VALUES ('dept-type', '126', '临床体液、血液', '126');
INSERT INTO `sys_constant` VALUES ('dept-type', '127', '临床微生物学', '127');
INSERT INTO `sys_constant` VALUES ('dept-type', '128', '临床生化检验', '128');
INSERT INTO `sys_constant` VALUES ('dept-type', '129', '临床免疫、血清学', '129');
INSERT INTO `sys_constant` VALUES ('dept-type', '13', '老年病', '13');
INSERT INTO `sys_constant` VALUES ('dept-type', '130', '临床细胞分子遗传学', '130');
INSERT INTO `sys_constant` VALUES ('dept-type', '131', '其他', '131');
INSERT INTO `sys_constant` VALUES ('dept-type', '132', '病理科', '132');
INSERT INTO `sys_constant` VALUES ('dept-type', '133', '医学影像科', '133');
INSERT INTO `sys_constant` VALUES ('dept-type', '134', 'X线诊断', '134');
INSERT INTO `sys_constant` VALUES ('dept-type', '135', 'CT诊断', '135');
INSERT INTO `sys_constant` VALUES ('dept-type', '136', '磁共振成像诊断', '136');
INSERT INTO `sys_constant` VALUES ('dept-type', '137', '核医学', '137');
INSERT INTO `sys_constant` VALUES ('dept-type', '138', '超声诊断', '138');
INSERT INTO `sys_constant` VALUES ('dept-type', '139', '心电诊断', '139');
INSERT INTO `sys_constant` VALUES ('dept-type', '14', '其他', '14');
INSERT INTO `sys_constant` VALUES ('dept-type', '140', '脑电及脑血流图诊断', '140');
INSERT INTO `sys_constant` VALUES ('dept-type', '141', '神经肌肉电图', '141');
INSERT INTO `sys_constant` VALUES ('dept-type', '142', '介入放射学', '142');
INSERT INTO `sys_constant` VALUES ('dept-type', '143', '放射治疗', '143');
INSERT INTO `sys_constant` VALUES ('dept-type', '144', '其他', '144');
INSERT INTO `sys_constant` VALUES ('dept-type', '145', '中医科', '145');
INSERT INTO `sys_constant` VALUES ('dept-type', '146', '内科', '146');
INSERT INTO `sys_constant` VALUES ('dept-type', '147', '外科', '147');
INSERT INTO `sys_constant` VALUES ('dept-type', '148', '妇产科', '148');
INSERT INTO `sys_constant` VALUES ('dept-type', '149', '儿科', '149');
INSERT INTO `sys_constant` VALUES ('dept-type', '15', '外科', '15');
INSERT INTO `sys_constant` VALUES ('dept-type', '150', '皮肤科', '150');
INSERT INTO `sys_constant` VALUES ('dept-type', '151', '眼科', '151');
INSERT INTO `sys_constant` VALUES ('dept-type', '152', '耳鼻咽喉科', '152');
INSERT INTO `sys_constant` VALUES ('dept-type', '153', '口腔科', '153');
INSERT INTO `sys_constant` VALUES ('dept-type', '154', '肿瘤科', '154');
INSERT INTO `sys_constant` VALUES ('dept-type', '155', '骨伤科', '155');
INSERT INTO `sys_constant` VALUES ('dept-type', '156', '肛肠科', '156');
INSERT INTO `sys_constant` VALUES ('dept-type', '157', '老年病科', '157');
INSERT INTO `sys_constant` VALUES ('dept-type', '158', '针灸科', '158');
INSERT INTO `sys_constant` VALUES ('dept-type', '159', '推拿科', '159');
INSERT INTO `sys_constant` VALUES ('dept-type', '16', '普通外科', '16');
INSERT INTO `sys_constant` VALUES ('dept-type', '160', '康复医学', '160');
INSERT INTO `sys_constant` VALUES ('dept-type', '161', '急诊科', '161');
INSERT INTO `sys_constant` VALUES ('dept-type', '162', '预防保健科', '162');
INSERT INTO `sys_constant` VALUES ('dept-type', '163', '其他', '163');
INSERT INTO `sys_constant` VALUES ('dept-type', '164', '民族医学科', '164');
INSERT INTO `sys_constant` VALUES ('dept-type', '165', '维吾尔医学', '165');
INSERT INTO `sys_constant` VALUES ('dept-type', '166', '藏医学', '166');
INSERT INTO `sys_constant` VALUES ('dept-type', '167', '蒙医学', '167');
INSERT INTO `sys_constant` VALUES ('dept-type', '168', '彝医学', '168');
INSERT INTO `sys_constant` VALUES ('dept-type', '169', '傣医学', '169');
INSERT INTO `sys_constant` VALUES ('dept-type', '17', '肝脏移植项目', '17');
INSERT INTO `sys_constant` VALUES ('dept-type', '170', '其他', '170');
INSERT INTO `sys_constant` VALUES ('dept-type', '171', '中西医结合科', '171');
INSERT INTO `sys_constant` VALUES ('dept-type', '172', '其他业务科室', '172');
INSERT INTO `sys_constant` VALUES ('dept-type', '173', '传染病预防控制科(中心)', '173');
INSERT INTO `sys_constant` VALUES ('dept-type', '174', '性病艾滋病预防控制科(中心)', '174');
INSERT INTO `sys_constant` VALUES ('dept-type', '175', '结核病预防控制科(中心)', '175');
INSERT INTO `sys_constant` VALUES ('dept-type', '176', '血吸虫预防控制科(中心)', '176');
INSERT INTO `sys_constant` VALUES ('dept-type', '177', '慢性非传染性疾病预防控制科(中心)', '177');
INSERT INTO `sys_constant` VALUES ('dept-type', '178', '寄生虫病预防控制科(中心)', '178');
INSERT INTO `sys_constant` VALUES ('dept-type', '179', '地方病控制科(中心)', '179');
INSERT INTO `sys_constant` VALUES ('dept-type', '18', '胰腺移植项目', '18');
INSERT INTO `sys_constant` VALUES ('dept-type', '180', '精神卫生科(中心)', '180');
INSERT INTO `sys_constant` VALUES ('dept-type', '181', '妇幼保健科', '181');
INSERT INTO `sys_constant` VALUES ('dept-type', '182', '免疫规划科(中心)', '182');
INSERT INTO `sys_constant` VALUES ('dept-type', '183', '农村改水技术指导科(中心)', '183');
INSERT INTO `sys_constant` VALUES ('dept-type', '184', '疾病控制与应急处理办公室', '184');
INSERT INTO `sys_constant` VALUES ('dept-type', '185', '食品卫生科', '185');
INSERT INTO `sys_constant` VALUES ('dept-type', '186', '环境卫生所', '186');
INSERT INTO `sys_constant` VALUES ('dept-type', '187', '职业卫生科', '187');
INSERT INTO `sys_constant` VALUES ('dept-type', '188', '放射卫生科', '188');
INSERT INTO `sys_constant` VALUES ('dept-type', '189', '学校卫生科', '189');
INSERT INTO `sys_constant` VALUES ('dept-type', '19', '小肠移植项目', '19');
INSERT INTO `sys_constant` VALUES ('dept-type', '190', '健康教育科(中心)', '190');
INSERT INTO `sys_constant` VALUES ('dept-type', '191', '预防医学门诊', '191');
INSERT INTO `sys_constant` VALUES ('dept-type', '192', '其他业务科室', '192');
INSERT INTO `sys_constant` VALUES ('dept-type', '193', '综合卫生监督科', '193');
INSERT INTO `sys_constant` VALUES ('dept-type', '194', '产品卫生监督科', '194');
INSERT INTO `sys_constant` VALUES ('dept-type', '195', '职业卫生监督科', '195');
INSERT INTO `sys_constant` VALUES ('dept-type', '196', '环境卫生监督科', '196');
INSERT INTO `sys_constant` VALUES ('dept-type', '197', '传染病执法监督科', '197');
INSERT INTO `sys_constant` VALUES ('dept-type', '198', '医疗服务监督科', '198');
INSERT INTO `sys_constant` VALUES ('dept-type', '199', '稽查科(大队)', '199');
INSERT INTO `sys_constant` VALUES ('dept-type', '2', '全科医疗科', '2');
INSERT INTO `sys_constant` VALUES ('dept-type', '20', '神经外科', '20');
INSERT INTO `sys_constant` VALUES ('dept-type', '200', '许可受理科', '200');
INSERT INTO `sys_constant` VALUES ('dept-type', '201', '放射卫生监督科', '201');
INSERT INTO `sys_constant` VALUES ('dept-type', '202', '学校卫生监督科', '202');
INSERT INTO `sys_constant` VALUES ('dept-type', '203', '食品安全监督科', '203');
INSERT INTO `sys_constant` VALUES ('dept-type', '204', '其他', '204');
INSERT INTO `sys_constant` VALUES ('dept-type', '205', '护理部', '205');
INSERT INTO `sys_constant` VALUES ('dept-type', '206', '药剂科(药房)', '206');
INSERT INTO `sys_constant` VALUES ('dept-type', '207', '感染科', '207');
INSERT INTO `sys_constant` VALUES ('dept-type', '208', '输血科(血库)', '208');
INSERT INTO `sys_constant` VALUES ('dept-type', '209', '办公室', '209');
INSERT INTO `sys_constant` VALUES ('dept-type', '21', '骨科', '21');
INSERT INTO `sys_constant` VALUES ('dept-type', '210', '人事科', '210');
INSERT INTO `sys_constant` VALUES ('dept-type', '211', '财务科', '211');
INSERT INTO `sys_constant` VALUES ('dept-type', '212', '设备科', '212');
INSERT INTO `sys_constant` VALUES ('dept-type', '213', '信息科(中心)', '213');
INSERT INTO `sys_constant` VALUES ('dept-type', '214', '医政科', '214');
INSERT INTO `sys_constant` VALUES ('dept-type', '215', '教育培训科', '215');
INSERT INTO `sys_constant` VALUES ('dept-type', '216', '总务科', '216');
INSERT INTO `sys_constant` VALUES ('dept-type', '217', '新农合管理办公室', '217');
INSERT INTO `sys_constant` VALUES ('dept-type', '218', '其他科室', '218');
INSERT INTO `sys_constant` VALUES ('dept-type', '22', '泌尿外科', '22');
INSERT INTO `sys_constant` VALUES ('dept-type', '23', '肾脏移植项目', '23');
INSERT INTO `sys_constant` VALUES ('dept-type', '24', '胸外科', '24');
INSERT INTO `sys_constant` VALUES ('dept-type', '25', '肺脏移植项目', '25');
INSERT INTO `sys_constant` VALUES ('dept-type', '26', '心脏大血管外科', '26');
INSERT INTO `sys_constant` VALUES ('dept-type', '27', '心脏移植项目', '27');
INSERT INTO `sys_constant` VALUES ('dept-type', '28', '烧伤科', '28');
INSERT INTO `sys_constant` VALUES ('dept-type', '29', '整形外科', '29');
INSERT INTO `sys_constant` VALUES ('dept-type', '3', '内科', '3');
INSERT INTO `sys_constant` VALUES ('dept-type', '30', '其他', '30');
INSERT INTO `sys_constant` VALUES ('dept-type', '31', '妇产科', '31');
INSERT INTO `sys_constant` VALUES ('dept-type', '32', '妇科', '32');
INSERT INTO `sys_constant` VALUES ('dept-type', '33', '产科', '33');
INSERT INTO `sys_constant` VALUES ('dept-type', '34', '计划生育', '34');
INSERT INTO `sys_constant` VALUES ('dept-type', '35', '优生学', '35');
INSERT INTO `sys_constant` VALUES ('dept-type', '36', '生殖健康与不孕症', '36');
INSERT INTO `sys_constant` VALUES ('dept-type', '37', '其他', '37');
INSERT INTO `sys_constant` VALUES ('dept-type', '38', '妇女保健科', '38');
INSERT INTO `sys_constant` VALUES ('dept-type', '39', '青春期保健', '39');
INSERT INTO `sys_constant` VALUES ('dept-type', '4', '呼吸内科', '4');
INSERT INTO `sys_constant` VALUES ('dept-type', '40', '围产期保健', '40');
INSERT INTO `sys_constant` VALUES ('dept-type', '41', '更年期保健', '41');
INSERT INTO `sys_constant` VALUES ('dept-type', '42', '妇女心理卫生', '42');
INSERT INTO `sys_constant` VALUES ('dept-type', '43', '妇女营养', '43');
INSERT INTO `sys_constant` VALUES ('dept-type', '44', '其他', '44');
INSERT INTO `sys_constant` VALUES ('dept-type', '45', '儿科', '45');
INSERT INTO `sys_constant` VALUES ('dept-type', '46', '新生儿', '46');
INSERT INTO `sys_constant` VALUES ('dept-type', '47', '小儿传染病', '47');
INSERT INTO `sys_constant` VALUES ('dept-type', '48', '小儿消化', '48');
INSERT INTO `sys_constant` VALUES ('dept-type', '49', '小儿呼吸', '49');
INSERT INTO `sys_constant` VALUES ('dept-type', '5', '消化内科', '5');
INSERT INTO `sys_constant` VALUES ('dept-type', '50', '小儿心脏病', '50');
INSERT INTO `sys_constant` VALUES ('dept-type', '51', '小儿肾病', '51');
INSERT INTO `sys_constant` VALUES ('dept-type', '52', '小儿血液病', '52');
INSERT INTO `sys_constant` VALUES ('dept-type', '53', '小儿神经病学', '53');
INSERT INTO `sys_constant` VALUES ('dept-type', '54', '小儿内分泌', '54');
INSERT INTO `sys_constant` VALUES ('dept-type', '55', '小儿遗传病', '55');
INSERT INTO `sys_constant` VALUES ('dept-type', '56', '小儿免疫', '56');
INSERT INTO `sys_constant` VALUES ('dept-type', '57', '其他', '57');
INSERT INTO `sys_constant` VALUES ('dept-type', '58', '小儿外科', '58');
INSERT INTO `sys_constant` VALUES ('dept-type', '59', '小儿普通外科', '59');
INSERT INTO `sys_constant` VALUES ('dept-type', '6', '神经内科', '6');
INSERT INTO `sys_constant` VALUES ('dept-type', '60', '小儿骨科', '60');
INSERT INTO `sys_constant` VALUES ('dept-type', '61', '小儿泌尿外科', '61');
INSERT INTO `sys_constant` VALUES ('dept-type', '62', '小儿胸心外科', '62');
INSERT INTO `sys_constant` VALUES ('dept-type', '63', '小儿神经外科', '63');
INSERT INTO `sys_constant` VALUES ('dept-type', '64', '其他', '64');
INSERT INTO `sys_constant` VALUES ('dept-type', '65', '儿童保健科', '65');
INSERT INTO `sys_constant` VALUES ('dept-type', '66', '儿童生长发育', '66');
INSERT INTO `sys_constant` VALUES ('dept-type', '67', '儿童营养', '67');
INSERT INTO `sys_constant` VALUES ('dept-type', '68', '儿童心理卫生', '68');
INSERT INTO `sys_constant` VALUES ('dept-type', '69', '儿童五官保健', '69');
INSERT INTO `sys_constant` VALUES ('dept-type', '7', '心血管内科', '7');
INSERT INTO `sys_constant` VALUES ('dept-type', '70', '儿童康复', '70');
INSERT INTO `sys_constant` VALUES ('dept-type', '71', '其他', '71');
INSERT INTO `sys_constant` VALUES ('dept-type', '72', '眼科', '72');
INSERT INTO `sys_constant` VALUES ('dept-type', '73', '耳鼻咽喉科', '73');
INSERT INTO `sys_constant` VALUES ('dept-type', '74', '耳科', '74');
INSERT INTO `sys_constant` VALUES ('dept-type', '75', '鼻科', '75');
INSERT INTO `sys_constant` VALUES ('dept-type', '76', '咽喉科', '76');
INSERT INTO `sys_constant` VALUES ('dept-type', '77', '其他', '77');
INSERT INTO `sys_constant` VALUES ('dept-type', '78', '口腔科', '78');
INSERT INTO `sys_constant` VALUES ('dept-type', '79', '口腔内科', '79');
INSERT INTO `sys_constant` VALUES ('dept-type', '8', '血液内科', '8');
INSERT INTO `sys_constant` VALUES ('dept-type', '80', '口腔颌面外科', '80');
INSERT INTO `sys_constant` VALUES ('dept-type', '81', '正畸', '81');
INSERT INTO `sys_constant` VALUES ('dept-type', '82', '口腔修复', '82');
INSERT INTO `sys_constant` VALUES ('dept-type', '83', '口腔预防保健', '83');
INSERT INTO `sys_constant` VALUES ('dept-type', '84', '其他', '84');
INSERT INTO `sys_constant` VALUES ('dept-type', '85', '皮肤科', '85');
INSERT INTO `sys_constant` VALUES ('dept-type', '86', '皮肤病', '86');
INSERT INTO `sys_constant` VALUES ('dept-type', '87', '性传播疾病', '87');
INSERT INTO `sys_constant` VALUES ('dept-type', '88', '其他', '88');
INSERT INTO `sys_constant` VALUES ('dept-type', '89', '医疗美容科', '89');
INSERT INTO `sys_constant` VALUES ('dept-type', '9', '肾病学', '9');
INSERT INTO `sys_constant` VALUES ('dept-type', '90', '精神科', '90');
INSERT INTO `sys_constant` VALUES ('dept-type', '91', '精神病', '91');
INSERT INTO `sys_constant` VALUES ('dept-type', '92', '精神卫生', '92');
INSERT INTO `sys_constant` VALUES ('dept-type', '93', '药物依赖', '93');
INSERT INTO `sys_constant` VALUES ('dept-type', '94', '精神康复', '94');
INSERT INTO `sys_constant` VALUES ('dept-type', '95', '社区防治', '95');
INSERT INTO `sys_constant` VALUES ('dept-type', '96', '临床心理', '96');
INSERT INTO `sys_constant` VALUES ('dept-type', '97', '司法精神', '97');
INSERT INTO `sys_constant` VALUES ('dept-type', '98', '其他', '98');
INSERT INTO `sys_constant` VALUES ('dept-type', '99', '传染科', '99');
INSERT INTO `sys_constant` VALUES ('education-type', '0', '其他', '5');
INSERT INTO `sys_constant` VALUES ('education-type', '1', '全日制', '1');
INSERT INTO `sys_constant` VALUES ('education-type', '2', '函授', '2');
INSERT INTO `sys_constant` VALUES ('education-type', '3', '成人教育', '3');
INSERT INTO `sys_constant` VALUES ('education-type', '4', '继续教育', '4');
INSERT INTO `sys_constant` VALUES ('identification-type', '1', '身份证', '1');
INSERT INTO `sys_constant` VALUES ('identification-type', '2', '居民户口簿', '2');
INSERT INTO `sys_constant` VALUES ('identification-type', '3', '护照', '3');
INSERT INTO `sys_constant` VALUES ('identification-type', '4', '军官证', '4');
INSERT INTO `sys_constant` VALUES ('identification-type', '5', '驾驶执照', '5');
INSERT INTO `sys_constant` VALUES ('identification-type', '6', '港澳居民来往内地通行证', '6');
INSERT INTO `sys_constant` VALUES ('identification-type', '7', '台湾居民来往内地通行证', '7');
INSERT INTO `sys_constant` VALUES ('identification-type', '8', '其他', '8');
INSERT INTO `sys_constant` VALUES ('item-target-type', '1', '医疗机构', '1');
INSERT INTO `sys_constant` VALUES ('item-target-type', '2', '医疗人员', '2');
INSERT INTO `sys_constant` VALUES ('item-target-type', '3', '医疗相关人员', '3');
INSERT INTO `sys_constant` VALUES ('job-situation-type', '1', '党委(副)书记', '1');
INSERT INTO `sys_constant` VALUES ('job-situation-type', '2', '院(所、站)长', '2');
INSERT INTO `sys_constant` VALUES ('job-situation-type', '3', '副院(所、站)长', '3');
INSERT INTO `sys_constant` VALUES ('job-situation-type', '4', '科室主任', '4');
INSERT INTO `sys_constant` VALUES ('job-situation-type', '5', '科室副主任', '5');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '1', '执业医师', '1');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '10', '中药师(士)', '10');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '11', '检验技师(士)', '11');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '12', '影像技师(士)', '12');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '13', '其他卫生技术人员', '13');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '14', '其他技术人员', '14');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '15', '管理人员 ', '15');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '16', '工勤技能人员 ', '16');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '2', '执业助理医师', '2');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '3', '见习医师', '3');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '4', '全科医生', '4');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '5', '乡村医生', '5');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '6', '乡村执业助理医师', '6');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '7', '注册护士', '7');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '8', '助产士', '8');
INSERT INTO `sys_constant` VALUES ('major-technology-type', '9', '西药师(士)', '9');
INSERT INTO `sys_constant` VALUES ('major-type', '1', '哲学', '1');
INSERT INTO `sys_constant` VALUES ('major-type', '10', '医学', '10');
INSERT INTO `sys_constant` VALUES ('major-type', '11', '基础医学类', '11');
INSERT INTO `sys_constant` VALUES ('major-type', '12', '预防医学类', '12');
INSERT INTO `sys_constant` VALUES ('major-type', '13', '临床医学与医学技术类', '13');
INSERT INTO `sys_constant` VALUES ('major-type', '14', '临床医学', '14');
INSERT INTO `sys_constant` VALUES ('major-type', '15', '麻醉学', '15');
INSERT INTO `sys_constant` VALUES ('major-type', '16', '医学影像学', '16');
INSERT INTO `sys_constant` VALUES ('major-type', '17', '医学检验', '17');
INSERT INTO `sys_constant` VALUES ('major-type', '18', '其他医学技术专业', '18');
INSERT INTO `sys_constant` VALUES ('major-type', '19', '口腔医学', '19');
INSERT INTO `sys_constant` VALUES ('major-type', '2', '经济学', '2');
INSERT INTO `sys_constant` VALUES ('major-type', '20', '中医学类', '20');
INSERT INTO `sys_constant` VALUES ('major-type', '21', '中医学', '21');
INSERT INTO `sys_constant` VALUES ('major-type', '22', '针灸推拿学', '22');
INSERT INTO `sys_constant` VALUES ('major-type', '23', '中医学类其他专', '23');
INSERT INTO `sys_constant` VALUES ('major-type', '24', '法医学', '24');
INSERT INTO `sys_constant` VALUES ('major-type', '25', '护理学', '25');
INSERT INTO `sys_constant` VALUES ('major-type', '26', '药学类', '26');
INSERT INTO `sys_constant` VALUES ('major-type', '27', '药学', '27');
INSERT INTO `sys_constant` VALUES ('major-type', '28', '中药学', '28');
INSERT INTO `sys_constant` VALUES ('major-type', '29', '其他药学专业', '29');
INSERT INTO `sys_constant` VALUES ('major-type', '3', '法学', '3');
INSERT INTO `sys_constant` VALUES ('major-type', '30', '管理类', '30');
INSERT INTO `sys_constant` VALUES ('major-type', '4', '教育学', '4');
INSERT INTO `sys_constant` VALUES ('major-type', '5', '文学', '5');
INSERT INTO `sys_constant` VALUES ('major-type', '6', '历史学', '6');
INSERT INTO `sys_constant` VALUES ('major-type', '7', '理学', '7');
INSERT INTO `sys_constant` VALUES ('major-type', '8', '工学', '8');
INSERT INTO `sys_constant` VALUES ('major-type', '9', '农学', '9');
INSERT INTO `sys_constant` VALUES ('nation-type', '1', '汉族', '1');
INSERT INTO `sys_constant` VALUES ('nation-type', '10', '朝鲜族', '10');
INSERT INTO `sys_constant` VALUES ('nation-type', '11', '满族', '11');
INSERT INTO `sys_constant` VALUES ('nation-type', '12', '侗族', '12');
INSERT INTO `sys_constant` VALUES ('nation-type', '13', '瑶族', '13');
INSERT INTO `sys_constant` VALUES ('nation-type', '14', '白族', '14');
INSERT INTO `sys_constant` VALUES ('nation-type', '15', '土家族', '15');
INSERT INTO `sys_constant` VALUES ('nation-type', '16', '哈尼族', '16');
INSERT INTO `sys_constant` VALUES ('nation-type', '17', '哈萨克族', '17');
INSERT INTO `sys_constant` VALUES ('nation-type', '18', '傣族', '18');
INSERT INTO `sys_constant` VALUES ('nation-type', '19', '黎族', '19');
INSERT INTO `sys_constant` VALUES ('nation-type', '2', '蒙古族', '2');
INSERT INTO `sys_constant` VALUES ('nation-type', '20', '僳僳族', '20');
INSERT INTO `sys_constant` VALUES ('nation-type', '21', '佤族', '21');
INSERT INTO `sys_constant` VALUES ('nation-type', '22', '畲族', '22');
INSERT INTO `sys_constant` VALUES ('nation-type', '23', '高山族', '23');
INSERT INTO `sys_constant` VALUES ('nation-type', '24', '拉祜族', '24');
INSERT INTO `sys_constant` VALUES ('nation-type', '25', '水族', '25');
INSERT INTO `sys_constant` VALUES ('nation-type', '26', '东乡族', '26');
INSERT INTO `sys_constant` VALUES ('nation-type', '27', '纳西族', '27');
INSERT INTO `sys_constant` VALUES ('nation-type', '28', '景颇族', '28');
INSERT INTO `sys_constant` VALUES ('nation-type', '29', '柯尔克孜族', '29');
INSERT INTO `sys_constant` VALUES ('nation-type', '3', '回族', '3');
INSERT INTO `sys_constant` VALUES ('nation-type', '30', '土族', '30');
INSERT INTO `sys_constant` VALUES ('nation-type', '31', '达斡尔族', '31');
INSERT INTO `sys_constant` VALUES ('nation-type', '32', '仫佬族', '32');
INSERT INTO `sys_constant` VALUES ('nation-type', '33', '羌族', '33');
INSERT INTO `sys_constant` VALUES ('nation-type', '34', '布朗族', '34');
INSERT INTO `sys_constant` VALUES ('nation-type', '35', '撤拉族', '35');
INSERT INTO `sys_constant` VALUES ('nation-type', '36', '毛南族', '36');
INSERT INTO `sys_constant` VALUES ('nation-type', '37', '仡佬族', '37');
INSERT INTO `sys_constant` VALUES ('nation-type', '38', '锡伯族', '38');
INSERT INTO `sys_constant` VALUES ('nation-type', '39', '阿昌族', '39');
INSERT INTO `sys_constant` VALUES ('nation-type', '4', '藏族', '4');
INSERT INTO `sys_constant` VALUES ('nation-type', '40', '普米族', '40');
INSERT INTO `sys_constant` VALUES ('nation-type', '41', '塔吉克族', '41');
INSERT INTO `sys_constant` VALUES ('nation-type', '42', '怒族', '42');
INSERT INTO `sys_constant` VALUES ('nation-type', '43', '乌孜别克族', '43');
INSERT INTO `sys_constant` VALUES ('nation-type', '44', '俄罗斯族', '44');
INSERT INTO `sys_constant` VALUES ('nation-type', '45', '鄂温克族', '45');
INSERT INTO `sys_constant` VALUES ('nation-type', '46', '崩龙族', '46');
INSERT INTO `sys_constant` VALUES ('nation-type', '47', '保安族', '47');
INSERT INTO `sys_constant` VALUES ('nation-type', '48', '裕固族', '48');
INSERT INTO `sys_constant` VALUES ('nation-type', '49', '京族', '49');
INSERT INTO `sys_constant` VALUES ('nation-type', '5', '维吾尔族', '5');
INSERT INTO `sys_constant` VALUES ('nation-type', '50', '塔塔尔族', '50');
INSERT INTO `sys_constant` VALUES ('nation-type', '51', '独龙族', '51');
INSERT INTO `sys_constant` VALUES ('nation-type', '52', '鄂伦春族', '52');
INSERT INTO `sys_constant` VALUES ('nation-type', '53', '赫哲族', '53');
INSERT INTO `sys_constant` VALUES ('nation-type', '54', '门巴族', '54');
INSERT INTO `sys_constant` VALUES ('nation-type', '55', '珞巴族', '55');
INSERT INTO `sys_constant` VALUES ('nation-type', '56', '基诺族', '56');
INSERT INTO `sys_constant` VALUES ('nation-type', '57', '外籍', '57');
INSERT INTO `sys_constant` VALUES ('nation-type', '58', '不详', '58');
INSERT INTO `sys_constant` VALUES ('nation-type', '6', '苗族', '6');
INSERT INTO `sys_constant` VALUES ('nation-type', '7', '彝族', '7');
INSERT INTO `sys_constant` VALUES ('nation-type', '8', '壮族', '8');
INSERT INTO `sys_constant` VALUES ('nation-type', '9', '布依族', '9');
INSERT INTO `sys_constant` VALUES ('notice-type', '0', '公告', '0');
INSERT INTO `sys_constant` VALUES ('notice-type', '1', '文件', '1');
INSERT INTO `sys_constant` VALUES ('personnel-type', '1', '医师类', '1');
INSERT INTO `sys_constant` VALUES ('personnel-type', '2', '护师类', '2');
INSERT INTO `sys_constant` VALUES ('personnel-type', '3', '乡村医生类', '3');
INSERT INTO `sys_constant` VALUES ('personnel-type', '4', '技师类', '4');
INSERT INTO `sys_constant` VALUES ('personnel-type', '5', '药师类', '5');
INSERT INTO `sys_constant` VALUES ('personnel-type', '6', '管理类', '6');
INSERT INTO `sys_constant` VALUES ('personnel-type', '7', '工勤类', '7');
INSERT INTO `sys_constant` VALUES ('personnel-type', '8', '其他', '8');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '1', '中共党员', '1');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '10', '九三学社社员', '10');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '11', '台盟盟员', '11');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '12', '无党派人士', '12');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '13', '中共预备党员', '13');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '2', '群众', '3');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '3', '共青团员', '2');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '4', '民革会员', '4');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '5', '民盟盟员', '5');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '6', '民建会员', '6');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '7', '民进会员', '7');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '8', '农工党党员', '8');
INSERT INTO `sys_constant` VALUES ('political-affiliation-type', '9', '致公党党员', '9');
INSERT INTO `sys_constant` VALUES ('positional-type', '1', '卫生类', '1');
INSERT INTO `sys_constant` VALUES ('positional-type', '2', '非卫生类', '2');
INSERT INTO `sys_constant` VALUES ('practice-category-type', '1', '临床', '1');
INSERT INTO `sys_constant` VALUES ('practice-category-type', '2', '口腔', '2');
INSERT INTO `sys_constant` VALUES ('practice-category-type', '3', '公共卫生', '3');
INSERT INTO `sys_constant` VALUES ('practice-category-type', '4', '中医', '4');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '1', '内科专业', '1');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '10', '医学检验和病理专业', '10');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '11', '全科医学专业', '11');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '12', '急救医学专业', '12');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '13', '康复医学专业', '13');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '14', '预防保健专业', '14');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '15', '特种医学和军事医疗专业', '15');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '16', '计划生育技术服务专业', '16');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '17', '重症医疗专业', '17');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '18', '医疗美容专业', '18');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '19', '口腔专业', '19');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '2', '外科专业', '2');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '20', '口腔麻醉专业', '20');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '21', '口腔病理专业', '21');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '22', '口腔影像专业', '22');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '23', '公共卫生类别专业', '23');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '24', '中医专业', '24');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '25', '中西医结合专业', '25');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '26', '蒙医专业', '26');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '27', '藏医专业', '27');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '28', '维医专业', '28');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '29', '傣医专业', '29');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '3', '妇产科专业', '3');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '30', '省级以上卫生行政部门规定的其他专业 ', '30');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '31', '中医(精神)专业', '31');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '32', '全科医学专业', '32');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '4', '儿科专业', '4');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '5', '眼耳鼻咽喉科专业', '5');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '6', '皮肤病和性病科专业', '6');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '7', '精神卫生专业', '7');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '8', '职业病专业', '8');
INSERT INTO `sys_constant` VALUES ('practice-scope-type', '9', '医学影像和放射诊疗专业', '9');
INSERT INTO `sys_constant` VALUES ('publicity-message-status', '1', '待审核', '2');
INSERT INTO `sys_constant` VALUES ('publicity-message-status', '2', '被驳回', '3');
INSERT INTO `sys_constant` VALUES ('publicity-message-status', '9', '审核成功', '4');
INSERT INTO `sys_constant` VALUES ('publicity-message-type', '1', '一星级', '1');
INSERT INTO `sys_constant` VALUES ('publicity-message-type', '2', '二星级', '2');
INSERT INTO `sys_constant` VALUES ('publicity-message-type', '3', '三星级', '3');
INSERT INTO `sys_constant` VALUES ('role-level-type', '1', '个人', '1');
INSERT INTO `sys_constant` VALUES ('role-level-type', '2', '机构', '2');
INSERT INTO `sys_constant` VALUES ('role-level-type', '9', '管理员', '3');
INSERT INTO `sys_constant` VALUES ('science-education-type', '1', '课题', '1');
INSERT INTO `sys_constant` VALUES ('science-education-type', '2', '奖项', '2');
INSERT INTO `sys_constant` VALUES ('science-education-type', '3', '论文', '3');
INSERT INTO `sys_constant` VALUES ('selection-grade-type', '1', 'A类', '1');
INSERT INTO `sys_constant` VALUES ('selection-grade-type', '2', 'B类', '2');
INSERT INTO `sys_constant` VALUES ('selection-grade-type', '3', 'C类', '3');
INSERT INTO `sys_constant` VALUES ('selection-grade-type', '4', 'D类', '4');
INSERT INTO `sys_constant` VALUES ('selection-grade-type', '5', 'E类', '5');
INSERT INTO `sys_constant` VALUES ('sex-type', '0', '女', '2');
INSERT INTO `sys_constant` VALUES ('sex-type', '1', '男', '1');
INSERT INTO `sys_constant` VALUES ('work-post-type', '1', '医生', '1');
INSERT INTO `sys_constant` VALUES ('work-post-type', '2', '护士', '2');
INSERT INTO `sys_constant` VALUES ('work-post-type', '3', '行政后勤', '3');

-- ----------------------------
-- Table structure for `sys_user`
-- ----------------------------
DROP TABLE IF EXISTS `sys_user`;
CREATE TABLE `sys_user` (
  `id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT 'id',
  `account` varchar(30) COLLATE utf8_unicode_ci NOT NULL COMMENT '账号',
  `password` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '密码',
  `cas_password` varchar(50) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '给cas登录的密码',
  `salt` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '盐',
  `user_id` varchar(32) COLLATE utf8_unicode_ci NOT NULL COMMENT '用户信息表ID',
  `is_first_login` tinyint(4) DEFAULT '1' COMMENT '是否第一次登录',
  `state` tinyint(4) DEFAULT '1' COMMENT '是否启用，0不启用',
  `type` tinyint(4) DEFAULT '0' COMMENT '是否管理员',
  `create_time` datetime DEFAULT NULL COMMENT '创建时间',
  `create_user_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '创建人',
  `update_time` datetime DEFAULT NULL COMMENT '更新时间',
  `update_user_id` varchar(32) COLLATE utf8_unicode_ci DEFAULT NULL COMMENT '更新人',
  `is_delete` tinyint(4) DEFAULT '0' COMMENT '是否删除',
  `last_login_time` datetime DEFAULT NULL COMMENT '最后登录时间',
  PRIMARY KEY (`id`),
  UNIQUE KEY `unique_account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of sys_user
-- ----------------------------
INSERT INTO `sys_user` VALUES ('1234', 'ceshi', '88a7d2182c9d500c84925dd3292dd709', null, '2a29f954227a613ecb66b08292ab6413', '', '0', '1', '1', '2019-03-22 09:59:42', '', '2018-04-10 08:42:01', 'ad313d38fe9447ce863fe8584743a010', '0', '2019-03-22 10:03:25');
INSERT INTO `sys_user` VALUES ('ad313d38fe9447ce863fe8584743a010', 'admin', 'b789f47d260c4d74d9e00cdf9f760cd2', 'AZICOnu9cyUFFvBp3xi1AA==', '987aa39cdb0fa2560c3d9e2bb0d88cd3', '', '0', '1', '1', '2019-03-22 09:59:44', null, '2019-06-03 15:41:54', 'ad313d38fe9447ce863fe8584743a010', '0', '2019-06-03 15:41:36');

-- ----------------------------
-- Table structure for `sys_visit_cache`
-- ----------------------------
DROP TABLE IF EXISTS `sys_visit_cache`;
CREATE TABLE `sys_visit_cache` (
  `id` varchar(32) NOT NULL,
  `ip` varchar(50) NOT NULL COMMENT 'IP',
  `code` varchar(20) NOT NULL COMMENT 'IP',
  `value` varchar(400) NOT NULL COMMENT '内容',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- ----------------------------
-- Records of sys_visit_cache
-- ----------------------------
INSERT INTO `sys_visit_cache` VALUES ('7255147bf46f4a7c815188a86b0477fa', '0:0:0:0:0:0:0:1', 'data_project_path', 'D:\\workspace2\\paladin-framework');

-- ----------------------------
-- Table structure for `tonto_container_version`
-- ----------------------------
DROP TABLE IF EXISTS `tonto_container_version`;
CREATE TABLE `tonto_container_version` (
  `id` varchar(50) COLLATE utf8_unicode_ci NOT NULL COMMENT '容器ID',
  `version` int(11) NOT NULL COMMENT '版本',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;

-- ----------------------------
-- Records of tonto_container_version
-- ----------------------------
INSERT INTO `tonto_container_version` VALUES ('constants_container', '1');
INSERT INTO `tonto_container_version` VALUES ('role_container', '1');
INSERT INTO `tonto_container_version` VALUES ('unit_container', '1');
