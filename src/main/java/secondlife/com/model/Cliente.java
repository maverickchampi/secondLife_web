package secondlife.com.model;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_cliente")
public class Cliente {
	@Id
	private String id_clie;	
	private String dni_clie;	
	private String nom_clie;	
	private String ape_clie;	
	private Date fec_nac_clie;	
	private String tel_clie;	
	private String id_log;	
    private int estado;

    /*-------Getters and Setters-----------*/
	public String getId_clie() {
		return id_clie;
	}

	public void setId_clie(String id_clie) {
		this.id_clie = id_clie;
	}

	public String getDni_clie() {
		return dni_clie;
	}

	public void setDni_clie(String dni_clie) {
		this.dni_clie = dni_clie;
	}

	public String getNom_clie() {
		return nom_clie;
	}

	public void setNom_clie(String nom_clie) {
		this.nom_clie = nom_clie;
	}

	public String getApe_clie() {
		return ape_clie;
	}

	public void setApe_clie(String ape_clie) {
		this.ape_clie = ape_clie;
	}

	public Date getFec_nac_clie() {
		return fec_nac_clie;
	}

	public void setFec_nac_clie(Date fec_nac_clie) {
		this.fec_nac_clie = fec_nac_clie;
	}

	public String getTel_clie() {
		return tel_clie;
	}

	public void setTel_clie(String tel_clie) {
		this.tel_clie = tel_clie;
	}

	public String getId_log() {
		return id_log;
	}

	public void setId_log(String id_log) {
		this.id_log = id_log;
	}

	public int getEstado() {
		return estado;
	}

	public void setEstado(int estado) {
		this.estado = estado;
	}
    
    
}
