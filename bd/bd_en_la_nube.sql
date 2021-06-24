use heroku_7bec99fd4e9c7a5;

/*DROP TABLE authorities;
DROP TABLE users;
DROP TABLE tb_tarjeta;
DROP TABLE tb_detalle_boleta;
DROP TABLE tb_boleta;
DROP TABLE tb_producto;
DROP TABLE tb_categoria;
DROP TABLE tb_direccion;
DROP TABLE tb_usuario;
DROP TABLE tb_rol;
DROP TABLE tb_distrito;
DROP TABLE tb_provincia;
DROP TABLE tb_departamento;*/

/*----------------categoria----------------*/
create table tb_categoria ( 
	id_categ int not null,
	nom_categ varchar(45) not null,
	descrip_categ varchar(256) not null,
	estado int not null	
);
/* estado
		1.- activo
		2.- desactivo
*/    
alter table tb_categoria 
	add constraint PKcateg primary key(id_categ),
    add constraint  UQcateg_nom unique (nom_categ ),
    add constraint CKcateg_est check (estado in (1, 2)),  
    alter estado set default 1;
    
/*----------------tabla rol----------------*/
create table tb_rol (
	id_rol int not null,
	nom_rol varchar(250) not null
);
alter table tb_rol
	add constraint PKrol primary key (id_rol),
    add constraint CKrol_nom check (length(nom_rol)>=3);
 

/*----------------tabla empleado----------------*/
create table tb_usuario (
	id_usua char(5) not null,   
	dni_usua char(8) not null,
	id_rol int not null,
	nom_usua  varchar(100) not null,
	ape_usua varchar(100) not null,
	tel_usua char(9),
	fec_nac_usua timestamp not null,
    
	usuario varchar(15) not null, 
	pass varchar(100) not null,  
	email_log varchar(100) not null,
    estado int 
);
alter table tb_usuario
	add constraint PKusua primary key (id_usua),
	add constraint FKusua_rol foreign key(id_rol) references tb_rol(id_rol),
    add constraint CKusua_dni check (length(dni_usua)=8),
    add constraint CKusua_dato check (length(nom_usua)>=2 and (length(ape_usua)>=2)),
    add constraint CKusua_tel check (length(tel_usua)=9),
    
    add constraint CKusua_user check (length(usuario)>=7),
    add constraint CKpass check (length(pass)>=7),
    add constraint CKlogin_email check (length(email_log)>=10),
    
	add constraint CKusua_est check (estado in (1, 2)),
	alter estado set default 1;

/*---------------tabla numero de cuenta----------------*/
create table tb_tarjeta (
	id_tarj char(5) not null,
    tip_tarj varchar(25) not null,
    num_tarj char(16) not null,
    fec_venc char(5) not null,
    cvv int not null,
    id_usua char(5) not null
);
alter table tb_tarjeta
	add constraint PKtarjeta primary key (id_tarj),
    add constraint FKtarj_usua foreign key(id_usua) references tb_usuario(id_usua),
    add constraint CKtarj_tip check (length(tip_tarj)>=4),
    add constraint CKtarj_num check (length(num_tarj)=16),
    add constraint CKtarj_cvv check (cvv>=100 and cvv<=999);
    
/*----------------tabla departamento----------------*/
DROP TABLE IF EXISTS tb_departamento;
create table tb_departamento (
	id_dep int not null,
	nom_dep varchar(100) not null
);
alter table tb_departamento
	add constraint PKdepar primary key (id_dep),
    add constraint CKdepar_nom check (length(nom_dep)>=3);

/*----------------tabla provincia ----------------*/
create table tb_provincia (
	id_prov int not null,
	id_dep int not null,
	nom_prov varchar(100) not null
);
alter table tb_provincia
	add constraint PKprov primary key(id_prov),
    add constraint FKprov_dep foreign key(id_dep) references tb_departamento(id_dep),
    add constraint CKprov_nom check (length(nom_prov)>=3);

/*----------------tabla registro----------------*/
create table tb_distrito ( -- (ESTABLECIMIENTO - Cercado de Lima)
    id_dist int not null,    
	id_prov int not null,    
	nom_dist varchar(100)
);
alter table tb_distrito 
	add constraint PKdist primary key(id_dist),
    add constraint FKdist_prov foreign key(id_prov) references tb_provincia(id_prov),
    add constraint CKdist_nom check (length(nom_dist)>=3);
    
/*----------------tabla direccion----------------*/
create table tb_direccion(
	id_direc char(5) not null,
    latitud decimal null,
    longitud decimal null,
    desc_direc varchar(256) not null,
    etiqueta varchar(15) not null,
    id_dist  int not null,
	id_usua char(5) not null
);
alter table tb_direccion
	add constraint PKdireccion primary key(id_direc),
     add constraint FKdirec_usua foreign key(id_usua) references tb_usuario(id_usua),
	add constraint FKdirec_dist foreign key(id_dist) references tb_distrito(id_dist),
	add constraint CKdirec_desc check (length(desc_direc)>=4);

/*----------------tabla producto----------------*/
create table tb_producto (
	id_prod char(5) not null,
    cod_prod char(10) not null,
	id_categ int not null,
    mar_prod varchar(100) not null,
    mod_prod varchar(100) not null,
	descrip_prod varchar(256) not null,
    observacion varchar(256) not null,
	fec_comp_prod timestamp not null default current_timestamp,
    stock int not null,
    precio decimal(8,2) not null,
	image varchar(256) not null,
    calidad decimal (4,2) not null,
	estado int
);
/* calidad
		0-3  >> mal estado: inservible, falta de algun componente fisico, daño grave en la pintura y/o cuerpo,
				software brickeado o bloqueado. (tiempo de uso < 2 años)
		3-5  >> estado regular: daño en la pintura, cuerpo dañado o software bloqueado. (tiempo de uso < 1 año)
		5-7  >> estado bueno: ligeros rayones en el cuerpo. (tiempo de uso < 6 meses)
        7-10 >> estado excelente: practicamente como nuevo sin señales de uso. (tiempo de uso < 3 meses)
	estado
		1.- activo (listo para la venta)
		2.- desactivo (en reparacion)
*/
alter table  tb_producto
	add constraint PKprod primary key (id_prod),
    add constraint FKprod_categ foreign key (id_categ) references tb_categoria(id_categ),
	add constraint CKprod_desc check (length(descrip_prod)>=10 and length(observacion)>=10),
    add constraint CKprod_cal_comp check (calidad>=0 and calidad<=10),
     add constraint CKprod_prec check (precio>=5.0),
    add constraint CKprod_esta check (estado in (1, 2)),
    alter estado set default 2;

/*----------------tabla boleta----------------*/
create table tb_boleta (
	num_bol char(8) not null,
	id_usua char(5) not null,
	tipo_pago int not null,
    descrip_pago varchar(30) not null,
    id_direc char(5) not null,
	fec_bol  timestamp not null default current_timestamp,
	impo_bol decimal(8,2) not null,
	envio decimal(8,2) not null,
	total_bol  decimal(8,2) not null
);
alter table tb_boleta
	add constraint PKbol primary key (num_bol),
    add constraint FKbol_usua foreign key (id_usua) references tb_usuario(id_usua),
    add constraint FKbol_direc foreign key (id_direc) references tb_direccion(id_direc),
    add constraint CKbol_impo check (impo_bol>=1.0),
    add constraint CKbol_envio check (envio>=0),
    add constraint CKbol_total check (total_bol>=5.0),
    add constraint CKtip_pago check (tipo_pago in (1, 2));   
    
/*
	1 - tarjeta
    2 - paypal
*/
 
/*----------------tabla detalle de boleta----------------*/
create table tb_detalle_boleta(
	num_det_bol CHAR(6) null,
	num_bol  CHAR(8) not null,
	id_prod char(5) not null,
	cant_prod  int not null,
	sub_tot  decimal(8,2) not null
);
alter table tb_detalle_boleta
	add constraint PKdetalbol primary key (num_det_bol),
    add constraint FKdetalbol_bol foreign key (num_bol) references tb_boleta (num_bol),
    add constraint FKdetalbol_prod foreign key (id_prod) references tb_producto(id_prod),
    add constraint CKdetalbol_cant check (cant_prod>=1),
    add constraint CKdetalbol_sub check (sub_tot>=0);    
    

/*---------------------ingreso de datos-----------------------*/
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (1,'Laptops', 'Computadoras portátiles de peso y tamaño ligero, su tamaño es aproximado al de un portafolio.');
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (2,'Impresoras', 'Periféricos encargados de transferir las imágenes y textos de tu PC a papel.');
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (3,'Smartphones', 'Teléfonos celulares inteligentes.');
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (4,'Cámaras', "Aparatos para registrar imágenes estáticas o en movimiento.");
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (5,'Wearables', 'Dispositivos que se usan en el cuerpo humano y que interactúan con otros aparatos para transmitir o recoger algún tipo de datos.');
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (6,'Smart TV´s', 'Televisores inteligentes.');
insert into tb_categoria(id_categ,nom_categ, descrip_categ) values (7,'Audio', 'Dispositivos que reproducen, graban o procesan sonido.');

insert into tb_departamento values (1, 'Lima');

insert into tb_provincia values (1, 1, 'Lima');

insert into tb_distrito values (1, 1, 'Ancón');
insert into tb_distrito values (2, 1, 'Ate');
insert into tb_distrito values (3, 1, 'Barranco');   
insert into tb_distrito values (4, 1, 'Breña'); 
insert into tb_distrito values (5, 1, 'Carabayllo');
insert into tb_distrito values (6, 1, 'Chaclacayo');
insert into tb_distrito values (7, 1, 'Chorrillos');
insert into tb_distrito values (8, 1, 'Cieneguilla');
insert into tb_distrito values (9, 1, 'Comas');
insert into tb_distrito values (10, 1, 'El Agustino'); 
insert into tb_distrito values (11, 1, 'Independencia'); 
insert into tb_distrito values (12, 1, 'Jesús María');
insert into tb_distrito values (13, 1, 'La Molina');   
insert into tb_distrito values (14, 1, 'La Victoria');   
insert into tb_distrito values (15, 1, 'Lima Centro');  
insert into tb_distrito values (16, 1, 'Lince');   
insert into tb_distrito values (17, 1, 'Los Olivos');   
insert into tb_distrito values (18, 1, 'Lurín');  
insert into tb_distrito values (19, 1, 'Magdalena');  
insert into tb_distrito values (20, 1, 'Miraflores');   
insert into tb_distrito values (21, 1, 'Pachacamac'); 
insert into tb_distrito values (22, 1, 'Pucusana'); 
insert into tb_distrito values (23, 1, 'Pblo. Libre');  
insert into tb_distrito values (24, 1, 'Puente Piedra');   
insert into tb_distrito values (25, 1, 'Punta Hermosa'); 
insert into tb_distrito values (26, 1, 'Punta Negra'); 
insert into tb_distrito values (27, 1, 'Rímac'); 
insert into tb_distrito values (28, 1, 'San Bartolo');  
insert into tb_distrito values (29, 1, 'San Borja');  
insert into tb_distrito values (30, 1, 'San Isidro');  
insert into tb_distrito values (31, 1, 'San Juan de Lurigancho');  
insert into tb_distrito values (32, 1, 'San Juan de Miraflores');  
insert into tb_distrito values (33, 1, 'San Luis');   
insert into tb_distrito values (34, 1, 'San Martín de Porres');  
insert into tb_distrito values (35, 1, 'San Miguel');     
insert into tb_distrito values (36, 1, 'Santa Anita');     
insert into tb_distrito values (37, 1, 'Santa María del Mar'); 
insert into tb_distrito values (38, 1, 'Santa Rosa');       
insert into tb_distrito values (39, 1, 'Santiago de Surco');  
insert into tb_distrito values (40, 1, 'Surquillo');       
insert into tb_distrito values (41, 1, 'Villa El Salvador');     
insert into tb_distrito values (42, 1, 'Villa María del Triunfo');            

insert into tb_rol values (1, 'técnico infomático');
insert into tb_rol values (2, 'personal seguridad');
insert into tb_rol values (3, 'personal delivery');
insert into tb_rol values (4, 'cliente');
insert into tb_rol values (5, 'proveedor');

insert into tb_usuario values('us001','12345678', 4, 'Alex', 'Quispe Cavero', '987654321','2002-04-23', 'clientealex', '$2a$10$Wx/44JwiShgbvK16pezQDe4tyktF0kskmrgOoRd8tW7UcUh9sSFc6', 'alexelleon@gmail.com',1);

/*----------------------LAPTOPS-------------------------*/
insert into tb_producto values ('pd001', '632541-001', 1, 'HP', '15-dw1085la', 'Procesador: i3-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, pintura refaccionada', '2021-05-07', 20, 1500.0, 'https://i.ibb.co/V34qsXc/laptop1.png', 8.5, 1);
                                
insert into tb_producto values ('pd002', '632541-002', 1, 'HP', '15-dw10adde', 'Procesador: i3-10110U; RAM: 8GB DDR4; ROM: 128GB SSD; Pantalla: 15,6" FHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-05-15', 20, 1000.0, 'https://i.ibb.co/sCXrvQh/laptop2.png', 7.5, 1);
  
insert into tb_producto values ('pd003', '632541-003', 1, 'HP', '67-dw1085la', 'Procesador: i5-10110U; RAM: 4GB DDR4; ROM: 256GB SSD; Pantalla: 15,6" FHD',
								 'Equipo en buen estado, completamente restaurado','2021-05-25', 20, 800.0, 'https://i.ibb.co/Bfc83F3/laptop3.png', 7.0, 1);
                                
insert into tb_producto values ('pd004', '732685-001', 1, 'Apple', 'Macbook Air 11', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, pintura refaccionada','2020-07-07', 20, 4000.0, 'https://i.ibb.co/dbJnhfR/laptop4.png', 8.5, 1);

insert into tb_producto values ('pd005', '732685-002', 1, 'Apple', 'Macbook Air 12', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								 'Equipo en buen estado, sistema instalado y puerto usb reparado', '2020-07-15', 20,  2700.0, 'https://i.ibb.co/kqzq1yW/laptop5.png', 7.5, 1);

insert into tb_producto values ('pd006', '732685-003', 1, 'Apple', 'Macbook Air 13', 'Procesador: M1; RAM: 8GB; ROM: 256GB; Pantalla: 13" FHD',
								'Equipo en buen estado, completamente restaurado','2020-07-25', 20, 2000.0, 'https://i.ibb.co/WDCYBxj/laptop6.png', 7.0, 1);
 
insert into tb_producto values ('pd007', '852147-001', 1, 'ASUS', 'ROG Zephyrus G15', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2020-11-07', 20, 7000.0, 'https://i.ibb.co/kKcfKmm/laptop7.png', 7.0, 1);
                                
insert into tb_producto values ('pd008', '852147-002', 1, 'ASUS', 'ROG Zephyrus G18', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, pintura refaccionada', '2021-11-13', 20, 6000.0, 'https://i.ibb.co/q051xyd/laptop8.png', 8.5, 1);
                                
insert into tb_producto values ('pd009', '852147-003', 1, 'ASUS', 'ROG Zephyrus G20', 'Procesador:Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, sistema instalado y puerto usb reparado', '2021-11-25', 20, 5500.0, 'https://i.ibb.co/W3RxTMC/laptop9.png', 7.5, 1);
                                
insert into tb_producto values ('pd010', '852147-004', 1, 'ASUS', 'ROG Zephyrus G21', 'Procesador: Ryzen 9 4900HS; RAM: 16GB; ROM: 1TB SSD; Pantalla: 14" QHD',
								'Equipo en buen estado, completamente restaurado', '2021-11-30', 20, 5000.0, 'https://i.ibb.co/KK66N8J/laptop10.png', 2.0, 1);


/*----------------------IMPRESORAS-------------------------*/
insert into tb_producto values ('pd011', '524786-001', 2, 'HP', 'Multifuncional Ink Tank 218', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 20, 700.0, 'https://i.ibb.co/vJBbzRj/impresora1.png', 8.5, 1);
                        
insert into tb_producto values ('pd012', '524786-002', 2, 'HP', 'Multifuncional Ink Tank 415', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 21, 650.0, 'https://i.ibb.co/5jfw7M5/impresora2.png', 7.5, 1);
                                
insert into tb_producto values ('pd013', '524786-003', 2, 'HP', 'Multifuncional Ink Tank 625', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%','2020-07-25', 21, 550.0, 'https://i.ibb.co/k4XF5B7/impresora3.png', 7.0, 1);
                                
insert into tb_producto values ('pd014', '374905-001', 2, 'CANON', 'Multifuncional Color G2112', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07',21, 500.0, 'https://i.ibb.co/ZdZPpSQ/impresora4.png', 8.5, 1);
                                
insert into tb_producto values ('pd015', '374905-002', 2, 'CANON', 'Multifuncional Color G2114', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 21,  450.0, 'https://i.ibb.co/NLBT7hK/impresora5.png', 7.5, 1);
                                
insert into tb_producto values ('pd016', '374905-003', 2, 'CANON', 'Multifuncional Color G2118', 'Capacidad: 100 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 21, 400.0, 'https://i.ibb.co/hBg8Y9L/impresora6.png', 7.0, 1);
                                
insert into tb_producto values ('pd017', '842364-001', 2, 'Epson', 'Multifuncional Wifi EcoTank L4161', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, pintura refaccionada y tinta al 100%', '2020-07-07', 21, 1000.0, 'https://i.ibb.co/0cqnMQv/impresora7.png', 8.5, 1);
                                
insert into tb_producto values ('pd018', '842364-002', 2, 'Epson', 'Multifuncional Wifi EcoTank L4162', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, partes refaccionadas y tinta al 100%', '2020-07-15', 21, 850.0, 'https://i.ibb.co/kqxZ4VN/impresora8.png', 7.5, 1);
                                
insert into tb_producto values ('pd019', '842364-003', 2, 'Epson', 'Multifuncional Wifi EcoTank L4163', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25',21, 700.0, 'https://i.ibb.co/P5CQdQY/impresora9.png', 7.0, 1);
                                
insert into tb_producto values ('pd020', '842364-004', 2, 'Epson', 'Multifuncional Wifi EcoTank L4164', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado y tinta al 100%', '2020-07-25', 21, 650.0, 'https://i.ibb.co/G7SGpPd/impresora10.png', 7.0, 1);
              
              
/*----------------------SMARTPHONES-------------------------*/
insert into tb_producto values ('pd021', '125487-001', 3, 'Apple', 'iPhone XR Yellow', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 21, 4000.0, 'https://i.ibb.co/YRzrH3S/iphonexr.png', 8.5, 1);
                                
insert into tb_producto values ('pd022', '125487-002', 3, 'Apple', 'iPhone 11 Pink', 'Pantalla: 6.1" FHD+; RAM: 4GB; ROM: 128GB; Procesador: A14 Bionic; Cámara posterior: 12MP; Cámara frontal: 12MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 21, 3800.0, 'https://i.ibb.co/0rrMZt5/iphone11promax.png', 7.5, 1);
                                
insert into tb_producto values ('pd023', '125487-003', 3, 'Apple', 'iPhone 12 Morado', 'Capacidad: 60 hojas; Wi-Fi: No; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 51, 3500.0, 'https://i.ibb.co/sv3sC6g/iphone12.png', 7.0, 1);

insert into tb_producto values ('pd024', '524861-001', 3, 'Xiaomi', 'Poco X3 NFC PRO Azul Noche' , 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 11, 1000.0, 'https://i.ibb.co/dMSH8kR/pocox3pro.png', 8.5, 1);
                                
insert into tb_producto values ('pd025', '524861-002', 3, 'Xiaomi', 'Poco X3 NFC Azul', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 21, 800.0, 'https://i.ibb.co/nf1bCP2/pocox3nfc.png', 7.5, 1);
                                
insert into tb_producto values ('pd026', '524861-003', 3, 'Xiaomi', 'Poco X3 Negro', 'Pantalla: 6.67" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 732G; Cámara posterior: 64MP; Cámara frontal: 20MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 21, 750.0, 'https://i.ibb.co/TrfXbbc/pocox3.png', 7.0, 1);
                                
insert into tb_producto values ('pd027', '993254-001', 3, 'Samsung', 'Galaxy A21 Azul', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, pintura refaccionada', '2020-07-07', 51, 1400.0, 'https://i.ibb.co/Gp7x3zx/galaxy21.png', 8.5, 1);
                                
insert into tb_producto values ('pd028', '993254-002', 3, 'Samsung', 'Galaxy A31 Rojo', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, vidrio reemplazado', '2020-07-15', 31, 1200.0, 'https://i.ibb.co/mb850K5/galaxy31.png', 7.5, 1);
                                
insert into tb_producto values ('pd029', '993254-003', 3, 'Samsung', 'Galaxy A31 Blanco', 'Pantalla: 6.7" FHD+; RAM: 6GB; ROM: 128GB; Procesador: Qualcomm Snapdragon 730; Cámara posterior: 40MP; Cámara frontal: 32MP',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 41, 800.0, 'https://i.ibb.co/0YXjPRK/galaxya51.png',  7.0, 1);
                                
insert into tb_producto values ('pd030', '993254-004', 3, 'Samsung', 'Galaxy A71 Negro', 'Capacidad: 100 hojas; Wi-Fi: Si; Bluetooth: No; NFC: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 750.0, 'https://i.ibb.co/fQqnpj3/galaxy71.png', 7.0, 1);



/*----------------------CÁMARAS-------------------------*/

insert into tb_producto values ('pd031', '640541-001', 4, 'SONY', 'ILCE9M2', 'Megapixeles: 24.2MP; Wi-Fi: Si; Bluetooth: Si; Peso: 1.56; Largo(cm): 7.75',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 13000.0, 'https://i.ibb.co/Zm7jX27/CAMARA-SONY-ILCE-9-M2.png', 7.0, 1);

insert into tb_producto values ('pd032', '640541-002', 4, 'SONY', 'ILCE-7C NEGRO', 'Megapixeles: 24.2MP; Wi-Fi: Si; Bluetooth: Si; Peso: 1.56; Largo(cm): 9.97',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 5300.0, 'https://i.ibb.co/wRJtStW/SONY-ILCE-7-C-Black-1-Main.png', 7.0, 1);

insert into tb_producto values ('pd033', '640541-003', 4, 'CANON', 'EOS 5D MARK IV 30.4 MM', 'Megapixeles: 30.4MP; Resolucion: 1368 x 758 ; Conexion: USB+HDMU; Video: 4K',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  41, 13000.0, 'https://i.ibb.co/qRxdNKJ/CANON-C-MARA-REFLEX-EOS-5-D-MARK-IV-30-4-MM.png', 8.0, 1);

insert into tb_producto values ('pd034', '640541-004', 4, 'CANON', 'EOS M200 24.1MP', 'Megapixeles: 24.1MP; Color: negro; Peso: 262g; Conexion: USB+HDMU',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  20, 13000.0, 'https://i.ibb.co/xKbf8YL/CANON-C-MARA-MIRRORLESS-EOS-M200-24-1-MP.png', 7.0, 1);
                                
insert into tb_producto values ('pd035', '640541-005', 4, 'NIKON', 'D5 FX cuerpo versión XQD', 'Calidad de grabación: 4K Ultra HD; Distancia focal: Otro; Formatos de imagen: JPEG/RAW; Fuente de energía: Baterías',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  12, 17000.0, 'https://i.ibb.co/2q6TtWW/C-mara-R-flex-D5-FX-cuerpo-versi-n-XQD.png', 8.0, 1);
                                
insert into tb_producto values ('pd036', '640541-006', 4, 'NIKON', 'Z50 16-50 VR, 35 1.8 y FTZ', 'Alto: 9.3; Ancho: 6; Calidad de grabación: 4K Ultra HD; Formatos de imagen: JPEG/RAW; Fuente de energía: Baterías',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  12, 3000.0, 'https://i.ibb.co/Q8tcym2/C-mara-Mirrorless-Z50-16-50-VR-35-1-8-y-FTZ.png', 7.0, 1);
                                
insert into tb_producto values ('pd037', '640541-007', 4, 'PANASONIC', 'DCSD-GX850KPPK', 'Megapíxeles: 16.84 MP; Tamaño de la pantalla: 3 pulgadas; Formatos de imagen: JPEG/RAW; Sensibilidad ISO: Auto, 100-25600, (102400 max)',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1200.0, 'https://i.ibb.co/hZKf4Vt/C-mara-semiprofesional-4-K-Ultra-HD-16-84-mpx-DCSD-GX850-KPPK.png', 7.0, 1);
                                
insert into tb_producto values ('pd038', '640541-008', 4, 'PANASONIC', 'DCSD-GX850KPPS', 'Megapíxeles: 16.84 MP; Tamaño de la pantalla: 3 pulgadas; Formatos de imagen: JPEG/RAW; Sensibilidad ISO: Auto, 100-25600, (102400 max)',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  10, 1700.0, 'https://i.ibb.co/3MHRqmb/C-mara-semiprofesional-16-84-mpx-4-K-Ultra-HD-DCSD-GX850-KPPS.png', 7.0, 1);
                                
insert into tb_producto values ('pd039', '640541-009', 4, 'CANON', 'VIXIA HF W11', 'Tipo: Cámaras de video; Alto: 59.5 mm; Ancho: 60 mm; Calidad de grabación: Full HD, Memoria; 96GB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 1300.0, 'https://i.ibb.co/861vvLF/Camara-De-Video-Vixia-Hf-W11.png', 7.0, 1);
                                
insert into tb_producto values ('pd040', '640541-010', 4, 'SONY', 'FDR-AX43/BC UC2', 'Alto: 8.05 cm; Ancho: 7.3 cm; Calidad de grabación: 4K Ultra HD; Distancia focal: Otro; Formatos de imagen: JPEG/XAVCX/MP4',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 2500.0, 'https://i.ibb.co/23mYnwt/C-mara-de-video-FDR-AX43-sensor-CMOS-Exmor-R.png', 7.0, 1);

/*----------------------WEAREABLES-------------------------*/

insert into tb_producto values ('pd041', '857701-001', 5, 'SAMSUNG', 'SM-R810NZKAPEO', 'Memoria interna: 4 GB; Tamaño de Pantalla: 1.2"; Resolución de Pantalla: 360x360 px; Bluetooth: Bluetooth v4.2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 11, 2500.0, 'https://i.ibb.co/PGzbZS0/pe-galaxy-watch-r810-sm-r810nzkapeo-frontblack-117616162.png', 8.0, 1);

insert into tb_producto values ('pd042', '857701-002', 5, 'SAMSUNG', 'SM-R830NZDAPEO', 'Carcasa: 40 mm; Correa: 20 mm; Dimensiones: 39,5 mm x 39,5 mm x 10,5 mm; Peso (sin correa): 25 g; Pantalla: OLED de 1,1 pulgadas (360 x 360); Procesador: Exynos 9110 de doble núcleo a 1,15 GHz; Almacenamiento: 4GB; RAM: 750 MB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1100.0, 'https://i.ibb.co/XZwc7ZD/Galaxy-Watch-Active2-40mm-Pink.png', 7.0, 1);

insert into tb_producto values ('pd043', '857701-003', 5, 'SAMSUNG', 'SM-R220NZKALTA', 'Sensores: Acelerómetro, Giroscopio, Sensor óptico de frecuencia cardíaca; Memoria: 2MB(RAM); Interna 32 MB',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 300.0, 'https://i.ibb.co/f4LRNjH/Galaxy-Fit2-Black.png', 7.0, 1);

insert into tb_producto values ('pd044', '857701-004', 5, 'HUAWEI', 'HUAWEI Band 6 Amber Sunrise', '96 modos de ejercicio diferentes; Medición de SpO2 día y noche;  Pantalla FullView; Duración de la batería de 2 semanas; Compatible con Android e iOS*',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 150.0, 'https://i.ibb.co/cv2STsY/orange-plp.png', 8.0, 1);

insert into tb_producto values ('pd045', '857701-005', 5, 'HUAWEI', 'HUAWEI WATCH FIT Black', 'Pantalla AMOLED brillante de 1.64 pulgadas; Animaciones de entrenamiento rápido; Detección de saturación de oxígeno SPO2; Compatible con Android e iOS*',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 300.0, 'https://i.ibb.co/MpRfnHv/HUAWEI-WATCH-FIT-Black.png', 7.0, 1);

insert into tb_producto values ('pd046', '857701-006', 5, 'APPLE', 'Apple Watch Series 5', 'Sistema operativo: watchOS 6; Almacenamiento: 32GB; Sensores: Accelerometer, Altimeter, Barometer, Compass, Gyroscope, Heart Rate, Light Sensor; Rastreador: Si; Micrófono: Si; Altavoz incorporado: Si; Vibración; Si',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1300.0, 'https://i.ibb.co/Cm1Lssv/Promart-Apple-Watch-Series-5-GPS-44mm-Rose-Gold.png', 8.0, 1);

insert into tb_producto values ('pd047', '857701-007', 5, 'APPLE', 'SERIES 3 GPS 42MM GRIS ESPACIAL', '8 GB de capacidad; Pantalla de vidrio Ion-X; Cubierta trasera de composite; Wifi (802.11b/g/n a 2,4 GHz); Bluetooth 4.2; Hasta 18 horas de autonomía2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 2500.0, 'https://i.ibb.co/R38hM1Q/APPLE-WATCH-SERIES-3-42-MM-GPS-COLOR-GRIS-ESPACIAL.png', 5.0, 1);

/*----------------------SMART TV'S-------------------------*/

insert into tb_producto values ('pd048', '260022-001', 6, 'AOC', '55U6295', 'Tamaño de Pantalla: 55"; Tipo de Pantalla: LED; Smart TV:	Sí; Diseño de pantalla: Plana; Definición de Pantalla: 4K UHD; WiFi integrado: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 1400.0, 'https://i.ibb.co/7CW8tQK/TV-AOC-LED-Smart-55-55-U6295.png', 7.0, 1);
		
insert into tb_producto values ('pd049', '260022-002', 6, 'AOC', '32S5295', 'Tamaño de Pantalla: 32"; Tipo de Pantalla: LED; Diseño de pantalla: Plana; Definición: HD; WiFi: Sí; Bluetooth: No; Cámara: No; Entradas HDMI: 3',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 700.0, 'https://i.ibb.co/R20fwBr/TV-AOC-LED-HD-Smart-32-32-S5295.png', 6.0, 1);

insert into tb_producto values ('pd050', '260022-003', 6, 'LG', '55NANO80SPA', 'Tamaño: 55"; Pantalla:	Panel IPS 4K Nano cell; Dimming: Local Dimming; Resolución: 3840x 2160 px; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: webOS 6.0',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 3000.0, 'https://i.ibb.co/yYh7xwv/TV-LG-LED-4-K-Nano-Cell-Thin-Q-AI-55-55-NANO80-2021.png', 8.0, 1);

insert into tb_producto values ('pd051', '260022-004', 6, 'LG', '32LM637B', 'Tamaño: 32"; Pantalla: LED; Resolución: 1280x720 px; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: webOS 4.5',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  21, 700.0, 'https://i.ibb.co/vwbW8NK/TV-LG-LED-HD-Thin-Q-AI-32-32-LM637-B.png', 7.0, 1);

insert into tb_producto values ('pd052', '260022-005', 6, 'MIRAY', 'MS32-T1000BT', 'Tamaño: 32"; Pantalla: LED; Resolucion: 1366x768 px; Diseño: Plana; Definición: HD; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Android 9',
								'Equipo en buen estado, completamente restaurado', '2020-07-25', 21, 1100.0, 'https://i.ibb.co/Chm5n4S/TV-Miray-LED-HD-Smart-32-MS32-T1000-BT.png', 8.0, 1);

insert into tb_producto values ('pd053', '260022-006', 6, 'MIRAY', 'MK50-E201', 'Tamaño: 50"; Pantalla: LED; Diseño: Plana; Definición: 4K UHD; WiFi: Sí; Bluetooth: No; Sistema Operativo: Linux; Cámara: No; Entradas HDMI: 3',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1500.0, 'https://i.ibb.co/cDtzrCW/TV-Miray-LED-4-K-UHD-Smart-50-MK50-E201.png', 7.0, 1);

insert into tb_producto values ('pd054', '260022-007', 6, 'PHILIPS', '70PUD6774', 'Tamaño: 70"; Tipo: LED; Diseño: Plana; Definición: 4K UHD; WiFi: Sí; Bluetooth: No; Cámara: No; Entradas HDMI: 3; Puertos USB: 2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 2500.0, 'https://i.ibb.co/xH5McRR/TV-Philips-4-K-UHD-LED-Smart-70-70-PUD6774.png', 8.0, 1);

insert into tb_producto values ('pd055', '260022-008', 6, 'PHILIPS', 'PUD6654', 'Tamaño de Pantalla: 55"; Tipo de Pantalla: LED; Smart TV:	Sí; Diseño de pantalla: Plana; Definición de Pantalla: 4K UHD; WiFi integrado: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1400.0, 'https://i.ibb.co/7QVYdS5/TV-Philips-LED-4-K-UHD-Smart-50-50-PUD6654.png', 8.0, 1);

insert into tb_producto values ('pd056', '260022-009', 6, 'SAMSUNG', 'UN43AU7000GXPE', 'Tamaño: 43"; Pantalla: LED; Definición: 4K Ultra HD; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Tizen; Cámara: No; Entradas HDMI: 3; Entradas ethernet: 1',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 1500.0, 'https://i.ibb.co/QQMjX7j/TV-Samsung-LED-4-K-UHD-Smart-43-UN43-AU7000-GXPE.png', 7.0, 1);

insert into tb_producto values ('pd057', '260022-010', 6, 'SAMSUNG', 'QN50Q60AAGXPE', 'Tamaño: 50"; Pantalla: QLED; Definición: 4K; WiFi: Sí; Bluetooth: Sí; Sistema Operativo: Tizen: Cámara: No; Entradas HDMI: 3; Entradas ethernet: 1; Puertos USB: 2',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  12, 2000.0, 'https://i.ibb.co/hV6fLc4/TV-Samsung-LED-4-K-QLED-Smart-50-QN50-Q60-AAGXPE.png', 8.0, 1);

/*----------------------AUDIO-------------------------*/

insert into tb_producto values ('pd058', '840188-001', 7, 'ANTRYX', 'S. KLIPER 7.1 AGH-8000SR7', 'Audio: 7.1; Inalámbrico: No; Micrófono: Si; Control: No; Plegable: No; Cancelacion de ruido: No',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 120.0, 'https://i.ibb.co/njjJLPR/Aud-fono-Antryx-S-KLIPER-7-1-AGH-8000-SR7.png', 7.0, 1);

insert into tb_producto values ('pd059', '840188-002', 7, 'ANTRYX', 'Enigma', 'Inalámbrico: No; Micrófono: Sí; Control de volumen: Sí; Plegable: No; Potencia: 112dB ± 3dB; Sensibilidad: -42 ± 3dB; Frecuencia: 20 Hz a 20000 Hz',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 140.0, 'https://i.ibb.co/WnWJxjz/Aud-fono-con-micr-fono-Antryx-Enigma.png', 7.0, 1);

insert into tb_producto values ('pd060', '840188-003', 7, 'HYPERX', 'HX-HSCA-RD/AM', 'Inalámbrico: No; Micrófono: Sí; Control de volumenç: Sí; Plegable: No; Sensibilidad: -43dBV (0dB=1V/Pa,1kHz); Impedencia: 65Ω; Cancelacion de ruido:	Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 230.0, 'https://i.ibb.co/F3NWg1d/Aud-fono-Hyper-X-Cloud-Alpha.png', 7.0, 1);

insert into tb_producto values ('pd061', '840188-004', 7, 'HYPERX', 'HX-HSCLS-BL/AM', 'Inalámbrico: No; Micrófono: Si; Control de volumen: Si; Plegable: No; Cancelacion de ruido: No; Sensibilidad: -39dBV (0dB=1V/Pa,1kHz); Impedencia: 41Ω; Cancelacion de ruido: Sí',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 230.0, 'https://i.ibb.co/JrWHQ5h/Aud-fono-Hyper-X-Cloud-for-PS4.png', 7.0, 1);

insert into tb_producto values ('pd062', '840188-005', 7, 'CORSAIR', 'HS70 Pro', 'Peso: 330g; tipo de audifonos: Over Ear; Inalámbrico: Sí; Micrófono: Sí; Control de volumen: Sí; Plegable: Sí; Alcance: 12 Mtr; Batería: 16 horas; Sensibilidad: 111dB (+/-3dB); Frecuencia: 20 Hz a 20 kHz',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 340.0, 'https://i.ibb.co/X2hmHmM/Aud-fonos-Gamer-HS70-Pro-Wireless-Cream.png', 7.0, 1);

insert into tb_producto values ('pd063', '840188-006', 7, 'LG', 'PM7', 'Alto: 12.7 cm; Ancho: 33.3 cm; Profundidad: 16.3 cm; Inalámbrico: Sí; Potencia	30 W; Funciones destacadas: bluetooth speaker',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 340.0, 'https://i.ibb.co/4NQ73Lr/Parlante-Port-til-LG-XBOOM-Go-PM7-2020.png', 7.0, 1);

insert into tb_producto values ('pd064', '840188-007', 7, 'SONY', 'SRS-XB33/BC LA', 'Alto: 9.7 cm; Ancho: 24.6 cm; Inalámbrico: Sí; Iluminación estética: Sí; Tipo de Batería: Batería integrada; Duración de la batería: Hasta 24 horas',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 120.0, 'https://i.ibb.co/Jqb32Ft/Parlante-inal-mbrico-Sony-con-Bluetooth-y-Waterproof-SRS-XB33-Negro.png', 7.0, 1);

insert into tb_producto values ('pd065', '840188-008', 7, 'PIONEER', 'TS-A1600C', 'Potencia: 350W - 80W RMS; Funciones destacadas: - Tamaño de Tweeter: 29 mm, - Concepto de diseño de sonido Open & Smooth: Experimenta la excelencia en sonido y rendimiento para obtener un sonido óptimo en el automóvil.',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 350.0, 'https://i.ibb.co/crjj58q/Parlante-Pioneer-TS-A1600-C.png', 7.0, 1);

insert into tb_producto values ('pd066', '840188-009', 7, 'LOGITECH', 'Z407', 'Total de vatios (pico): 80W; Total de vatios reales (RMS): 40W; Subwoofer: 20W; Altavoces satélite: 2 x 10W; Entrada de 3.5 mm: 1; Entrada micro USB: 1; Bluetooth: 5.0',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 300.0, 'https://i.ibb.co/t3s8PFt/Z407-Bluetooth-Computer-Speakers-with-Subwoofer-and-Wireless-control.png', 7.0, 1);
insert into tb_producto values ('pd067', '840188-010', 7, 'LOGITECH', 'G560', 'Total de vatios de pico: 240 W; Total de vatios reales: 120 W; Versión de Bluetooth: 4.1; Confiable radio de acción de 25 metros con línea de visión directa; Entrada USB: 1; Toma de audífonos: 1',
								'Equipo en buen estado, completamente restaurado', '2020-07-25',  11, 600.0, 'https://i.ibb.co/pzbWbPt/G560.png', 7.0, 1);

/*
use bd_servicio_venta;
select*from tb_usuario;
select*from tb_boleta;
select*from tb_categoria;
select*from tb_cliente;
select*from tb_departamento;
select*from tb_detalle_boleta;
select*from distrito;
select*from tb_empleado;
select*from tb_login;
select*from tb_producto;
select*from tb_provincia;
select*from tb_registro;
select*from tb_rol;
*/

create table users (
	username varchar(50) primary key,
    password varchar(50),
    enabled tinyint(1)
);

create table authorities(
	username varchar(50),
    authority varchar(50)
);

