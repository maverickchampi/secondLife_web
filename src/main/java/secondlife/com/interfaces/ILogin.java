package secondlife.com.interfaces;

import org.springframework.data.jpa.repository.JpaRepository;

import secondlife.com.model.Login;

public interface ILogin extends JpaRepository<Login, String>{
//	public int validar(Login l);
}
