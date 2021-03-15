function [Delta_V_Hohmann,delta_t_trans,mass_ratio,r_0,alpha,a_trans,e_trans]=Hohmann_performance(R_E,r_LEO,Orbital_radius,mu,mu_earth,I_sp,g)
% Function that computes the HT performance for a chosen LEO height

r_0 = R_E+r_LEO; % Radius of the parking orbit [m]
alpha = Orbital_radius./r_0; % Radii ratio

% Semiaxis major transfer orbit [m] 
a_trans = (Orbital_radius + r_0)./2;

% Excentricity transfer orbit [m] 
e_trans = abs((r_0-Orbital_radius)./(r_0+Orbital_radius));

% Velocities [m/s]
V_LEO = sqrt(mu_earth./r_LEO);
V_earth = sqrt(mu./R_E);
V_0=V_earth+V_LEO;

% Total HT impulse required [m/s]
Delta_V_Hohmann = V_0.*( abs(sqrt(2.*alpha./(alpha+1))-1) + ...
    abs(sqrt(1./alpha)-sqrt(2./alpha-2./(1+alpha))));

% Transfer time [days]
delta_t_trans = pi * sqrt(a_trans.^3./mu)/3600/24;

% Mass variation ratio
mass_ratio = 1 - exp(-(Delta_V_Hohmann)./(I_sp * g));

end