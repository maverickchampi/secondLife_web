package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name="tb_registro")
public class Registro {
	@Id
	private String id_regis;
	private int id_categ;
	private String id_clie;
	private String descrip_prod;
	private String observacion;
	private String fecha_regis;
	private int stock;
	private double precio;
	private String image;
	private double calidad;
	private int estado;
	
	public String getId_regis() {
		return id_regis;
	}
	public void setId_regis(String id_regis) {
		this.id_regis = id_regis;
	}
	public int getId_categ() {
		return id_categ;
	}
	public void setId_categ(int id_categ) {
		this.id_categ = id_categ;
	}
	public String getId_clie() {
		return id_clie;
	}
	public void setId_clie(String id_clie) {
		this.id_clie = id_clie;
	}
	public String getDescrip_prod() {
		return descrip_prod;
	}
	public void setDescrip_prod(String descrip_prod) {
		this.descrip_prod = descrip_prod;
	}
	public String getObservacion() {
		return observacion;
	}
	public void setObservacion(String observacion) {
		this.observacion = observacion;
	}
	public String getFecha_regis() {
		return fecha_regis;
	}
	public void setFecha_regis(String fecha_regis) {
		this.fecha_regis = fecha_regis;
	}
	public int getStock() {
		return stock;
	}
	public void setStock(int stock) {
		this.stock = stock;
	}
	public double getPrecio() {
		return precio;
	}
	public void setPrecio(double precio) {
		this.precio = precio;
	}
	public String getImage() {
		return image;
	}
	public void setImage(String image) {
		this.image = image;
	}
	public double getCalidad() {
		return calidad;
	}
	public void setCalidad(double calidad) {
		this.calidad = calidad;
	}
	public int getEstado() {
		return estado;
	}
	public void setEstado(int estado) {
		this.estado = estado;
	}
	}
