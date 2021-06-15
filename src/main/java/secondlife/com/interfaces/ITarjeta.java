package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import secondlife.com.model.Tarjeta;

public interface ITarjeta extends JpaRepository<Tarjeta, String>{

	List<Tarjeta> findByUsuari(String id_usua);
	
}
