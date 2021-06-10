package secondlife.com.model;

import java.sql.Date;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


//@Getter
//@Setter
//@ToString
@Entity
@Table(name="tb_usuario")
public class Usuario {
	@Id
	private String id_usua; 
	private String dni_usua;
	private int id_rol;
	private String nom_usua;
	private String ape_usua;
	private String tel_usua;
	private Date fec_nac_usua;
	private String usuario;
	private String pass;  
	private String email_log;
	private int estado;
	
	public String getId_usua() {
		return id_usua;
	}
	public void setId_usua(String id_usua) {
		this.id_usua = id_usua;
	}
	public String getDni_usua() {
		return dni_usua;
	}
	public void setDni_usua(String dni_usua) {
		this.dni_usua = dni_usua;
	}
	public int getId_rol() {
		return id_rol;
	}
	public void setId_rol(int id_rol) {
		this.id_rol = id_rol;
	}
	public String getNom_usua() {
		return nom_usua;
	}
	public void setNom_usua(String nom_usua) {
		this.nom_usua = nom_usua;
	}
	public String getApe_usua() {
		return ape_usua;
	}
	public void setApe_usua(String ape_usua) {
		this.ape_usua = ape_usua;
	}
	public String getTel_usua() {
		return tel_usua;
	}
	public void setTel_usua(String tel_usua) {
		this.tel_usua = tel_usua;
	}
	public Date getFec_nac_usua() {
		return fec_nac_usua;
	}
	public void setFec_nac_usua(Date fec_nac_usua) {
		this.fec_nac_usua = fec_nac_usua;
	}
	public String getUsuario() {
		return usuario;
	}
	public void setUsuario(String usuario) {
		this.usuario = usuario;
	}
	public String getPass() {
		return pass;
	}
	public void setPass(String pass) {
		this.pass = pass;
	}
	public String getEmail_log() {
		return email_log;
	}
	public void setEmail_log(String email_log) {
		this.email_log = email_log;
	}
	public int getEstado() {
		return estado;
	}
	public void setEstado(int estado) {
		this.estado = estado;
	}
	
	
}
