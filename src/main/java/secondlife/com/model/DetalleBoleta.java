package secondlife.com.model;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.ManyToOne;
import javax.persistence.Table;


@Entity
@Table(name="tb_detalle_boleta")
public class DetalleBoleta {
	@Id
	private String num_det_bol;

	@Column(name = "num_bol")
	private String numBol;
	@Column(name = "id_prod")
	private String probBole;
	private int cant_prod;
	@Column(name = "sub_tot")
	private double subTot;
	@ManyToOne(fetch = FetchType.LAZY, cascade = CascadeType.ALL)
	private Boleta boleta;
	
	public Boleta getBoleta() {
		return boleta;
	}
	public void setBoleta(Boleta boleta) {
		this.boleta = boleta;
	}
	public String getNum_det_bol() {
		return num_det_bol;
	}
	public void setNum_det_bol(String num_det_bol) {
		this.num_det_bol = num_det_bol;
	}
	public String getNumBol() {
		return numBol;
	}
	public void setNumBol(String numBol) {
		this.numBol = numBol;
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
	public double getSubTot() {
		return subTot;
	}
	public void setSubTot(double subTot) {
		this.subTot = subTot;
	}

}
