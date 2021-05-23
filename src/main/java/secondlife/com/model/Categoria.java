package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_categoria")
public class Categoria {
	
	@Id
	private int id_categ;
	private String nom_categ;
	private String descrip_categ;
	private int estado;

	
	/*-------Getters and Setters-----------*/
	public int getId_categ() {
		return id_categ;
	}

	public void setId_categ(int id_categ) {
		this.id_categ = id_categ;
	}

	public String getNom_categ() {
		return nom_categ;
	}

	public void setNom_categ(String nom_categ) {
		this.nom_categ = nom_categ;
	}

	public String getDescrip_categ() {
		return descrip_categ;
	}

	public void setDescrip_categ(String descrip_categ) {
		this.descrip_categ = descrip_categ;
	}

	public int getEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}
	
	
}
