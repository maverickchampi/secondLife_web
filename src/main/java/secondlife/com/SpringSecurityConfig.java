package secondlife.com;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.method.configuration.EnableGlobalMethodSecurity;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityConfigurerAdapter;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;

@EnableGlobalMethodSecurity(securedEnabled = true, prePostEnabled = true)
@Configuration
public class SpringSecurityConfig extends WebSecurityConfigurerAdapter {

	@Autowired 
	private DataSource dataSource;
	@Autowired
	private BCryptPasswordEncoder passwordEncoder;

	@Bean
	public BCryptPasswordEncoder passwordEncoder() {
		return new BCryptPasswordEncoder();
	}

	protected void configure(HttpSecurity http) throws Exception {
		http.authorizeRequests()
				.antMatchers("/", "/bcrypt/**", "/css/**", "/js/**", "/img/**", "/index**", "/terminos**", "/carrito**","/admin**",
						"/productos**", "/producto**","/registrar**","/productos/{id}**","/producto/{id}**","/ReporteProductos/**","/ReporteCategorias/**")
				.permitAll() // TODO LO PERMITIDO SIN LOGUEAR
				// ACA VAN LOS ROLES Y LOS PERMISOS DE USUARIO
				.antMatchers("/perfil/**").hasAnyAuthority("cliente")
				.antMatchers("/cotizar/**").hasAnyAuthority("cliente")
				.antMatchers("/pago/**").hasAnyAuthority("cliente")
				.antMatchers("/tarjetaPago/**").hasAnyAuthority("cliente")
				.antMatchers("/perfil-direccion/{id}**").hasAnyAuthority("cliente")
				.antMatchers("/perfil-compra/{id}**").hasAnyAuthority("cliente")
				.antMatchers("/perfil-metodo/{id}**").hasAnyAuthority("cliente")
				.anyRequest().authenticated().and().formLogin().loginPage("/login").permitAll().and().logout()
				.permitAll();
	}

	@Autowired
	public void configurerGlobal(AuthenticationManagerBuilder builder) throws Exception {
		
		builder.jdbcAuthentication()
		.dataSource(dataSource)
		.passwordEncoder(passwordEncoder)
		.usersByUsernameQuery("select usuario,pass,estado from tb_usuario where usuario = ?") // 
		
		.authoritiesByUsernameQuery("select u.usuario,r.nom_rol,u.id_usua from tb_rol r inner join tb_usuario u on (r.id_rol=u.id_rol) where u.usuario = ?");
       
	}

}
