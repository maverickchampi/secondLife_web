package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_rol")
public class Rol {
	
	@Id
	private int id_rol;	
	private String nom_rol;	
	private double sue_min;	
	private double sue_max;
	
	/*-------Getters and Setters-----------*/
	public int getId_rol() {
		return id_rol;
	}

	public void setId_rol(int id_rol) {
		this.id_rol = id_rol;
	}

	public String getNom_rol() {
		return nom_rol;
	}

	public void setNom_rol(String nom_rol) {
		this.nom_rol = nom_rol;
	}

	public double getSue_min() {
		return sue_min;
	}

	public void setSue_min(double sue_min) {
		this.sue_min = sue_min;
	}

	public double getSue_max() {
		return sue_max;
	}

	public void setSue_max(double sue_max) {
		this.sue_max = sue_max;
	}
	
}
