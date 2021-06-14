package secondlife.com.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;

import secondlife.com.model.Usuario;

public interface IUsuario extends JpaRepository<Usuario, String>{
}
