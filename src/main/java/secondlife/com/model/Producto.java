package secondlife.com.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;
import javax.validation.constraints.NotEmpty;

@Entity
@Table(name="tb_producto")
public class Producto {
	@Id
	@Column(name = "id_prod")
	private String prod;
	private String cod_prod;
	@Column(name = "id_categ")
	private int categ;
	@NotEmpty
	private String mar_prod;
	private String mod_prod;	
	private String descrip_prod;
	private String observacion;
	private String fec_comp_prod;
	private int stock;
	private double precio;
	private String image;
	private double calidad;
	private int estado;
	
	
	
	public String getProd() {
		return prod;
	}
	public void setProd(String prod) {
		this.prod = prod;
	}
	public String getCod_prod() {
		return cod_prod;
	}
	public void setCod_prod(String cod_prod) {
		this.cod_prod = cod_prod;
	}
	public int getCateg() {
		return categ;
	}
	public void setCateg(int categ) {
		this.categ = categ;
	}
	public String getMar_prod() {
		return mar_prod;
	}
	public void setMar_prod(String mar_prod) {
		this.mar_prod = mar_prod;
	}
	public String getMod_prod() {
		return mod_prod;
	}
	public void setMod_prod(String mod_prod) {
		this.mod_prod = mod_prod;
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
	public String getFec_comp_prod() {
		return fec_comp_prod;
	}
	public void setFec_comp_prod(String fec_comp_prod) {
		this.fec_comp_prod = fec_comp_prod;
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
