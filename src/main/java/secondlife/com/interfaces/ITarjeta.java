package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import secondlife.com.model.Tarjeta;

public interface ITarjeta extends JpaRepository<Tarjeta, String>{

	List<Tarjeta> findByUsuari(String id_usua);

	 @Query(value="select * from tb_tarjeta t where t.id_tarj = :id_tarj", nativeQuery=true)
	 Tarjeta findByIdTarj(String id_tarj);
	 
	 @Modifying
	 @Transactional
	 @Query(value="delete from tb_tarjeta t where t.id_tarj = :id_tarj", nativeQuery=true)
	 void deleteDirecByIdTarj(String id_tarj);
	 
	 @Query(value="select id_tarj from tb_tarjeta order by id_tarj desc limit 1", nativeQuery=true)
	    String getLastCodigo();
}
