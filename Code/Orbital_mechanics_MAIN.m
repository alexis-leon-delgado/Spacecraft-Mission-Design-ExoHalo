%% ORBITAL MECHANICS CODE %%
% Program that computes the Hohmann Transfer performance and studies the
% variation of fuel mass used with respect to the propellant loaded

% Space Engineering - ESEIAAT
% Authors:
% Santi Villarroya Calavia
% Iván Sermanoukian Molina
% Yi Qiang Ji Zhang
% Alexis Leon Delgado
% Juan Garrido Moreno

% Preamble
clc;
clear;
close all;
set(groot,'defaultAxesTickLabelInterpreter','latex');
set(groot,'defaulttextinterpreter','latex');
set(groot,'defaultLegendInterpreter','latex');

%% INPUT DATA

G=6.6740831e-11; % Universal gravitational constant [N·m^2/kg^2]
M_Sun=1.98855e30; % Sun's Mass [kg]
M_T=5.972e24; % Earth's Mass [kg]
mu = G*M_Sun; % Sun's gravitational parameter [N·m^2/kg]
mu_earth = G*M_T; % Earths's gravitational parameter [N·m^2/kg]

R_E=149598023e3; % Earth orbital radius [m]
I_sp = 332; % Specific Impulse [s]
g = 9.80665; % Earth acceleration gravity [m/s^2]
L2=(M_T/(3*M_Sun))^(1/3)*R_E; % Distance between Earth and Sun-Earth L2 [m]
Orbital_radius = [R_E+L2]; % Semi-major axis of the L2 orbit around the Sun [m]

r_LEO=1000e3; % Chosen LEO height [m]
r_LEO_min=160e3; % Minimum LEO height [m]
r_LEO_max=1000e3; % Maximum LEO height [m]
r_LEO_vec=linspace(r_LEO_min,r_LEO_max,1000); % Vector of LEO heights [m]

%% HOHMANN TRANSFER PERFORMANCE COMPUTATION

% Calculation of the HT performance for the chosen LEO height:
[Delta_V_Hohmann,delta_t_trans,mass_ratio,r_0,alpha,a_trans,e_trans]=Hohmann_performance(R_E,r_LEO,Orbital_radius,mu,mu_earth,I_sp,g);
% Calculation of the HT performance for the entire LEO height vector:
[Delta_V_Hohmann_vec,delta_t_trans_vec,mass_ratio_vec,r_0_vec,alpha_vec,a_trans_vec,e_trans_vec]=Hohmann_performance(R_E,r_LEO_vec,Orbital_radius,mu,mu_earth,I_sp,g);

T=sqrt(4*pi^2/mu*Orbital_radius^3); % L2 transfer time [days]
V_earth = sqrt(mu./R_E); % Earth orbital velocity [m/s]
omega_Earth=V_earth/R_E; % Earth angular velocity [rad/s]
omega_L2=omega_Earth; % L2 angular velocity [rad/s]
theta_L2=rad2deg(omega_L2*delta_t_trans*3600*24); %
lead_angle=-theta_L2+180; % Lead angle from the L2 target to the SC

%% FUEL BUDGET COMPUTATION

% velocity budget
m_L2=2165; % Soyuz's maximum payload capability to L2
m_sc=400; % Mass of the Exohalo L2 spacecraft
m_main=1250; % Estimated maximum mass of the main passanger
m_ASAP=425; % Mass of the payload adapter
m_p_max=6638; % Maximum mass of fuel that can be loaded into Fregat upper stage
m_dry=902; % Fregat's dry mass
m_pl=m_sc+m_ASAP+m_main; % Payload mass

% Minimum mass budget required to perform the Hohmann transfer
delta_m_min=(m_pl+m_dry)*mass_ratio/(1-1.22*mass_ratio); 

m_p=1.22*delta_m_min; % Initial propellant mass chosen

% Propellant mass loaded vector
m_p_vec=linspace(1.22*delta_m_min,m_p_max,100);

% Calculation, for the chosen propellant mass, of the fuel for the transfer (m_fuel) and the total fuel of the 3 orbital actions (m_total):
[m_fuel,m_total]=fuel_mass_computation(m_p,m_dry,m_pl,mass_ratio);
% Calculation, for the vector of propellant mass, of the fuel for the transfer (m_fuel) and the total fuel of the 3 orbital actions (m_total):
[m_fuel_vec,m_total_vec]=fuel_mass_computation(m_p_vec,m_dry,m_pl,mass_ratio);

%% PLOTS

figure
plot(r_LEO_vec/1000,Delta_V_Hohmann_vec)
xlabel('LEO parking orbit height $h_{LEO}\;\left(\mathrm{km}\right)$'); ylabel('Impulse $\Delta V_{HT}\;\left(\mathrm{m}/\mathrm{s}\right)$')
% xline(m_p_max,'--');
grid on
grid minor
box on

figure
plot(r_LEO_vec/1000,mass_ratio_vec)
xlabel('LEO parking orbit height $h_{LEO}\;\left(\mathrm{km}\right)$'); ylabel('Mass ratio $\Delta m/m_0$')
% xline(m_p_max,'--');
grid on
grid minor
box on

figure
plot(r_LEO_vec/1000,delta_t_trans_vec)
xlabel('LEO parking orbit height $h_{LEO}\;\left(\mathrm{km}\right)$'); ylabel('Transfer time $\Delta t\;\left(\mathrm{days}\right)$')
% xline(m_p_max,'--');
grid on
grid minor
box on

figure
plot(m_p_vec,m_fuel_vec)
xlabel('Propellant mass loaded $m_p\;\left(\mathrm{kg}\right)$'); ylabel('Hohmann transfer fuel budget $\Delta m_{\mathrm{HT}}\;\left(\mathrm{kg}\right)$')
xline(m_p_max,'--');
text(m_p_max,450,'$m_{p,\;max}$','HorizontalAlignment','right','FontSize',12)
xline(1.22*delta_m_min,'--');
text(1.22*delta_m_min,450,'$m_{p,\;min}$','FontSize',12)
grid on
grid minor
box on