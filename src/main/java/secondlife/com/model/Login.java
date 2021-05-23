package secondlife.com.model;

import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_login")
public class Login {
	
	@Id
	private String id_log;
	private String usuario;
	private String pass;
	private String email_log;
	private int estado;

	/*-------Getters and Setters-----------*/
	public String getId_log() {
		return id_log;
	}

	public void setId_log(String id_log) {
		this.id_log = id_log;
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
