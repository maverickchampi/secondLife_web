package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_direccion")
public class Direccion {
	
	@Id
	private String id_direc;	
    private double latitud;    
    private double longitud;    
    private String desc_direc;    
    private String etiqueta;    
    private int id_dist;
    private String id_log;

    /*-------Getters and Setters-----------*/
	public String getId_direc() {
		return id_direc;
	}

	public void setId_direc(String id_direc) {
		this.id_direc = id_direc;
	}

	public double getLatitud() {
		return latitud;
	}

	public void setLatitud(double latitud) {
		this.latitud = latitud;
	}

	public double getLongitud() {
		return longitud;
	}

	public void setLongitud(double longitud) {
		this.longitud = longitud;
	}

	public String getDesc_direc() {
		return desc_direc;
	}

	public void setDesc_direc(String desc_direc) {
		this.desc_direc = desc_direc;
	}

	public String getEtiqueta() {
		return etiqueta;
	}

	public void setEtiqueta(String etiqueta) {
		this.etiqueta = etiqueta;
	}

	public int getId_dist() {
		return id_dist;
	}

	public void setId_dist(int id_dist) {
		this.id_dist = id_dist;
	}

	public String getId_log() {
		return id_log;
	}

	public void setId_log(String id_log) {
		this.id_log = id_log;
	}
      
}
