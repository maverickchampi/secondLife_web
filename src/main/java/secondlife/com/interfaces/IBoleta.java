package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import secondlife.com.model.Boleta;


public interface IBoleta extends JpaRepository<Boleta, String>{

	@Query(value="SELECT num_bol FROM tb_boleta where id_usua = :id_usua order by num_bol desc limit 1", nativeQuery=true)
    String getLastNum(String id_usua);
	
	List<Boleta> findByUsua(String usua);
	
	Boleta findByNumBol(String numBol);
	
	@Query(value="select num_bol from tb_boleta order by num_bol desc limit 1", nativeQuery=true)
    String getLastCodigo();
}
