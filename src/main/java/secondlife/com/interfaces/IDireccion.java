package secondlife.com.interfaces;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import secondlife.com.model.Direccion;

public interface IDireccion  extends JpaRepository<Direccion, String>{

    List<Direccion> findByUsuar(String id_usua);
}
