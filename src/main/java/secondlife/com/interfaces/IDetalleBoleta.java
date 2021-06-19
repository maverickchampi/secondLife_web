package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import secondlife.com.model.DetalleBoleta;

public interface IDetalleBoleta extends JpaRepository<DetalleBoleta, String>{
	
	List<DetalleBoleta> findByNumBol(String numBol);
	
	@Query(value="select num_det_bol from tb_detalle_boleta order by num_det_bol desc limit 1", nativeQuery=true)
    String getLastCodigo();
}
