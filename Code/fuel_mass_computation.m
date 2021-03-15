function [m_fuel,m_total]=fuel_mass_computation(m_p,m_dry,m_pl,mass_ratio)
% Function that computes, for the chosen propellant mass, the fuel required for the HT (m_fuel) and the total fuel (m_total) of the 3 orbital actions of transfer, attitude control and reserve fuel tasks

m_fregat=m_p+m_dry; % Mass of the Fregat upper stage
m_0=m_fregat+m_pl; % Initial mass at the HT's periapsis
m_fuel=mass_ratio.*m_0; % Fuel mass for the HT

m_att=0.07*m_fuel; % Mass of fuel required to perform attitude control maneuvers
m_margin=0.15*m_fuel; % Mass of fuel for margin purposes
m_total=m_fuel+m_att+m_margin; % Total fuel mass
end