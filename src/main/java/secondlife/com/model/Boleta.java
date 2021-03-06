package secondlife.com.model;

import java.util.List;

import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.FetchType;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.Table;


@Entity
@Table(name="tb_boleta")
public class Boleta {
	@Id
	@Column(name = "num_bol")
	private String numBol;
	@Column(name = "id_usua")
	private String usua;
	private int tipo_pago;
	private String descrip_pago;
	private String id_direc;
	private String fec_bol;
	private double impo_bol;
	private double envio;
	private double total_bol;
	@OneToMany(mappedBy="boleta",fetch=FetchType.LAZY,cascade=CascadeType.ALL)
	private List<DetalleBoleta> detalle_boleta;
	
	public List<DetalleBoleta> getDetalle_boleta() {
		return detalle_boleta;
	}
	public void setDetalle_boleta(List<DetalleBoleta> detalle_boleta) {
		this.detalle_boleta = detalle_boleta;
	}
	public String getNumBol() {
		return numBol;
	}
	public void setNumBol(String numBol) {
		this.numBol = numBol;
	}
	public String getUsua() {
		return usua;
	}
	public void setUsua(String usua) {
		this.usua = usua;
	}
	public int getTipo_pago() {
		return tipo_pago;
	}
	public void setTipo_pago(int tipo_pago) {
		this.tipo_pago = tipo_pago;
	}
	public String getDescrip_pago() {
		return descrip_pago;
	}
	public void setDescrip_pago(String descrip_pago) {
		this.descrip_pago = descrip_pago;
	}
	public String getId_direc() {
		return id_direc;
	}
	public void setId_direc(String id_direc) {
		this.id_direc = id_direc;
	}
	public String getFec_bol() {
		return fec_bol;
	}
	public void setFec_bol(String fec_bol) {
		this.fec_bol = fec_bol;
	}
	public double getImpo_bol() {
		return impo_bol;
	}
	public void setImpo_bol(double impo_bol) {
		this.impo_bol = impo_bol;
	}
	public double getEnvio() {
		return envio;
	}
	public void setEnvio(double envio) {
		this.envio = envio;
	}
	public double getTotal_bol() {
		return total_bol;
	}
	public void setTotal_bol(double total_bol) {
		this.total_bol = total_bol;
	}
}
