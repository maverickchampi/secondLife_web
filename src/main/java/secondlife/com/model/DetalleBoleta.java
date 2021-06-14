package secondlife.com.model;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.Table;


@Entity
@Table(name="tb_detalle_boleta")
public class DetalleBoleta {
	@Id
	private String num_det_bol;
	private String num_bol;
	@Column(name = "id_prod")
	private String probBole;
	private int cant_prod;
	private double sub_tot;
	
	public String getNum_det_bol() {
		return num_det_bol;
	}
	public void setNum_det_bol(String num_det_bol) {
		this.num_det_bol = num_det_bol;
	}
	public String getNum_bol() {
		return num_bol;
	}
	public void setNum_bol(String num_bol) {
		this.num_bol = num_bol;
	}
	public String getProbBole() {
		return probBole;
	}
	public void setProbBole(String probBole) {
		this.probBole = probBole;
	}
	public int getCant_prod() {
		return cant_prod;
	}
	public void setCant_prod(int cant_prod) {
		this.cant_prod = cant_prod;
	}
	public double getSub_tot() {
		return sub_tot;
	}
	public void setSub_tot(double sub_tot) {
		this.sub_tot = sub_tot;
	}

}
