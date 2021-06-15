package secondlife.com.model;

import java.util.Date;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table (name="tb_tarjeta")
public class Tarjeta {
	
	@Id
	private String id_tarj;
	private String tip_tarj;
	private String num_tarj;
	private String fec_venc;
	private int cvv;
	@Column(name = "id_usua")
    private String usuari;

	/*-------Getters and Setters-----------*/
	public String getId_tarj() {
		return id_tarj;
	}

	public void setId_tarj(String id_tarj) {
		this.id_tarj = id_tarj;
	}

	public String getTip_tarj() {
		return tip_tarj;
	}

	public void setTip_tarj(String tip_tarj) {
		this.tip_tarj = tip_tarj;
	}

	public String getNum_tarj() {
		return num_tarj;
	}

	public void setNum_tarj(String num_tarj) {
		this.num_tarj = num_tarj;
	}

	public String getFec_venc() {
		return fec_venc;
	}

	public void setFec_venc(String fec_venc) {
		this.fec_venc = fec_venc;
	}

	public int getCvv() {
		return cvv;
	}

	public void setCvv(int cvv) {
		this.cvv = cvv;
	}

	public String getUsuari() {
		return usuari;
	}

	public void setUsuari(String usuari) {
		this.usuari = usuari;
	}
	
} 
