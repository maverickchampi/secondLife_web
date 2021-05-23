package secondlife.com.model;

import java.util.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_empleado")
public class Empleado {
	@Id
	private String id_emp; 	
	private String dni_emp;	
	private int id_rol;	
	private String nom_emp;	
	private String ape_emp;	
	private String tel_emp;	
	private String dir_emp;	
	private Date fec_nac_emp;	
	private String obs_emp;	
	private double sue_emp;	
	private String id_log;    
	private int estado ;

	/*-------Getters and Setters-----------*/
	public String getId_emp() {
		return id_emp;
	}

	public void setId_emp(String id_emp) {
		this.id_emp = id_emp;
	}

	public String getDni_emp() {
		return dni_emp;
	}

	public void setDni_emp(String dni_emp) {
		this.dni_emp = dni_emp;
	}

	public int getId_rol() {
		return id_rol;
	}

	public void setId_rol(int id_rol) {
		this.id_rol = id_rol;
	}

	public String getNom_emp() {
		return nom_emp;
	}

	public void setNom_emp(String nom_emp) {
		this.nom_emp = nom_emp;
	}

	public String getApe_emp() {
		return ape_emp;
	}

	public void setApe_emp(String ape_emp) {
		this.ape_emp = ape_emp;
	}

	public String getTel_emp() {
		return tel_emp;
	}

	public void setTel_emp(String tel_emp) {
		this.tel_emp = tel_emp;
	}

	public String getDir_emp() {
		return dir_emp;
	}

	public void setDir_emp(String dir_emp) {
		this.dir_emp = dir_emp;
	}

	public Date getFec_nac_emp() {
		return fec_nac_emp;
	}

	public void setFec_nac_emp(Date fec_nac_emp) {
		this.fec_nac_emp = fec_nac_emp;
	}

	public String getObs_emp() {
		return obs_emp;
	}

	public void setObs_emp(String obs_emp) {
		this.obs_emp = obs_emp;
	}

	public double getSue_emp() {
		return sue_emp;
	}

	public void setSue_emp(double sue_emp) {
		this.sue_emp = sue_emp;
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
