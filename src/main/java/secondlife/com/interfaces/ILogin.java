package secondlife.com.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;

import secondlife.com.model.Login;
import secondlife.com.model.Producto;

public interface ILogin extends JpaRepository<Producto, String>{
	public int validar(Login l);
}
