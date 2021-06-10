package secondlife.com.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class LoginController {
	@GetMapping("/index")
	public String index() {
		return "index";
	}
	
	@GetMapping("/terminos")
	public String terminos() {
		return "terminos";
	}

	@GetMapping("/carrito")
	public String carrito() {
		return "carrito";
	}
	
	@GetMapping("/productos")
	public String productos() {
		return "productos";
	}

	@GetMapping("/producto")
	public String producto() {
		return "producto";
	}
	
	@GetMapping("/registrar")
	public String registrar() {
		return "registrar";
	}
	
	@GetMapping("/login")
	public String login() {
		return "login";
	}
	
	@GetMapping("/perfil")
	public String perfil() {
		return "perfil";
	}
	
	@GetMapping("/cotizar")
	public String cotizar() {
		return "cotizar";
	}
	
	@GetMapping("/admin")
	public String admin() {
		return "admin";
	}
}
