package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.transaction.annotation.Transactional;

import secondlife.com.model.Direccion;

public interface IDireccion  extends JpaRepository<Direccion, String>{

    List<Direccion> findByUsuar(String id_usua);
    
    Direccion findByIdDirec(String id_direc);
    
    @Modifying
    @Transactional
    @Query(value="delete from tb_direccion d where d.id_direc = :id_direc", nativeQuery=true)
    void deleteDirecByIdDirec(String id_direc);
    
    @Query(value="select id_direc from tb_direccion order by id_direc desc limit 1", nativeQuery=true)
    String getLastCodigo();
}
