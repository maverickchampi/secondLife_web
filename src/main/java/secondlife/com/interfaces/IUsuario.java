package secondlife.com.interfaces;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import secondlife.com.model.Usuario;

public interface IUsuario extends JpaRepository<Usuario, String>{
	
	Usuario findByUsuario(String usuario);
	
	@Query(value="select id_usua from tb_usuario order by id_usua desc limit 1", nativeQuery=true)
    String getLastCodigo();
}
