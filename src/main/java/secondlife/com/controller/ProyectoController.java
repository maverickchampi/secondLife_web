package secondlife.com.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;

import secondlife.com.interfaces.IProducto;
import secondlife.com.interfaces.IUsuario;
import secondlife.com.model.Usuario;

@Controller
public class ProyectoController {
	/*-------------------------*/
	@Autowired
	private IProducto ip;
	private IUsuario iu;
		
	/*-------------------------*/
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
	public String producto(Model model) {
		model.addAttribute("lstProducto", ip.findAll());
		return "producto";
	}
	
	@GetMapping("/registrar")
	public String registrar1(Usuario u, Model model) {
		return "registrar";
	}

	@PostMapping("/registrar")
	public String registrar(Usuario u, Model model) {
		iu.save(u);
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
}
