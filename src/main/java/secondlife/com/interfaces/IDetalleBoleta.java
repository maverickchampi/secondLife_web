package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import secondlife.com.model.DetalleBoleta;

public interface IDetalleBoleta extends JpaRepository<DetalleBoleta, String>{
	
	List<DetalleBoleta> findByNumBol(String numBol);
}
