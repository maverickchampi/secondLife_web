package secondlife.com.controller;

import java.security.Principal;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import secondlife.com.interfaces.IUsuario;
import secondlife.com.model.Usuario;

@Controller
public class LoginController {
	
	@Autowired 
    private PasswordEncoder passwordEncoder;
	
	@Autowired 
	private IUsuario iu;
	
	
	@GetMapping("/login")
	public String login(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout, Model model, Principal principal,
			RedirectAttributes flash) {
		if (principal != null) {
			flash.addFlashAttribute("info", "Ya ha iniciado sesion anteriormente");
			return "redirect:/perfil";
		}
		if (error != null) {
			model.addAttribute("error",
					"Error en el login: Nombre De usuario o contraseña incorrecta, Porfavor vuelva intentarlo");
		}
		if (logout != null) {
			model.addAttribute("success", "Ha cerrado session con exito!");
		}
		return "login";
	}
	
	@GetMapping("/registrar")
	public String registrar(@RequestParam(value = "error", required = false) String error,
			@RequestParam(value = "logout", required = false) String logout, Model model, Principal principal,
			RedirectAttributes flash) {
		if (principal != null) {
			flash.addFlashAttribute("info", "Ya ha iniciado sesion anteriormente");
			return "redirect:/perfil";
		}
		if (error != null) {
			model.addAttribute("error",
					"Error en el login: Nombre De usuario o contraseña incorrecta, Porfavor vuelva intentarlo");
		}
		if (logout != null) {
			model.addAttribute("success", "Ha cerrado session con exito!");
		}
		return "registrar";
	}
	
	@PostMapping("/registrar")
	public String registrarPost(Usuario u, Model model) {
		u.setPass(passwordEncoder.encode(u.getPass()));
		u.setId_usua("");
		u.setEstado(1);
		u.setId_rol(4);
		iu.save(u);
		return "registrar";
	}
	
}
