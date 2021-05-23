package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_distrito")
public class Distrito {
	
	@Id
	private int id_dist;  
	private int id_prov;   
	private String nom_dist;
	
	/*-------Getters and Setters-----------*/
	public int getId_dist() {
		return id_dist;
	}
	
	public void setId_dist(int id_dist) {
		this.id_dist = id_dist;
	}
	
	public int getId_prov() {
		return id_prov;
	}
	
	public void setId_prov(int id_prov) {
		this.id_prov = id_prov;
	}
	
	public String getNom_dist() {
		return nom_dist;
	}
	
	public void setNom_dist(String nom_dist) {
		this.nom_dist = nom_dist;
	}
	
	
}
