package secondlife.com.maintenance;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.jdbc.core.JdbcTemplate;

import secondlife.com.interfaces.ILogin;
import secondlife.com.model.Usuario;

public class MUsuario implements ILogin {

	@Autowired
	private JdbcTemplate jdbcTemplate;
	
	@Override
	public int validar(Usuario u) {
		
		return jdbcTemplate.update("select usuario,pass from tb_usuario where usuario = ?",
				u.getUsuario());
	}


}
