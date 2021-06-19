package secondlife.com.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_direccion")
public class Direccion {
	
	@Id
	@Column(name = "id_direc")
	private String idDirec;	
    private double latitud;    
    private double longitud;    
    private String desc_direc;    
    private String etiqueta;    
    private int id_dist;
	@Column(name = "id_usua")
    private String usuar;

    /*-------Getters and Setters-----------*/
	
	

	public double getLatitud() {
		return latitud;
	}

	public String getIdDirec() {
		return idDirec;
	}

	public void setIdDirec(String idDirec) {
		this.idDirec = idDirec;
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

	public String getUsuar() {
		return usuar;
	}

	public void setUsuar(String usuar) {
		this.usuar = usuar;
	}
}
