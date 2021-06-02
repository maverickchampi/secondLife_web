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
	@Autowired 
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
	public String productos(Model model) {
		model.addAttribute("lstProducto", prod.findAll());
		model.addAttribute("cantidad", prod.findAll().size()+" productos encontrados");
		return "productos";
	}

	@GetMapping("/producto")
	public String producto(Model model) {
<<<<<<< HEAD
		
=======
		model.addAttribute("lstProducto", ip.findAll());
>>>>>>> 826b121bad4b9cddf9ed74f6e01c4a1d649c1dfc
		return "producto";
	}
	
	@GetMapping("/registrar")
	public String registrar() {
		return "registrar";
	}

	@PostMapping("/registrar")
	public String registrarPost(Usuario u, Model model) {	
		Usuario usu = new Usuario();
		usu.setDni_usua("88888888");
		usu.setId_rol(4);
		usu.setNom_usua("aaaaaaaa");
		usu.setApe_usua("dddddddd");
		usu.setTel_usua("555555555");
		usu.setFec_nac_usua("2020-05-05");
		usu.setUsuario("aaaaaa");
		usu.setPass("aaaaaaa");
		usu.setEmail_log("ssss6@gmail.com");
		usu.setEstado(0);
		System.out.println(u);
		System.out.println(usu);
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
