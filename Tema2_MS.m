clc ;
close all ;
clear all ;

% Variabilele cunoscute
ro = 1000 ;
g = 9.8 ;

A1 = 0.06 ;
A2 = 0.06 ;
A4 = 0.06 ;
A3 = 0.06 ;

At = 0.1273 ;

a1 = 1.31 * ( 10 ^ ( -4 ) ) ;
a2 = 1.51 * ( 10 ^ ( -4 ) ) ;
a3 = 9.27 * ( 10 ^ ( -5 ) ) ;
a4 = 8.82 * ( 10 ^ ( -5 ) ) ;
ac = 4.307 * ( 10 ^ ( -6 ) ) ;

Q1tilda = 3.26 ;
Q2tilda = 4 ;

kp = 0.5 * ( 10 ^ ( -4 ) ) ;

gamma1 = 0.25 ;
gamma2 = 0.5 ;

% Valori initiale 1
h1 = 0 ; 
h2 = 0 ; 
h3 = 0 ; 
h4 = 0 ; 
h  = 0 ;


% Intrari( ustar )
T = 300 ;
t = linspace( 0, T, 1e4 ) ;
ustar = [ 0 0.5 1 2 2.3 2.4 2.7 3 3.5 4 ] ;

for i = 1 : length( ustar )
    u1in = timeseries( 0 .* double( t >= 0 ) .', t ) ;
    u2in = timeseries( ustar( i ) .* double( t >= 0 ) .', t ) ;
    
    load_system( 'schema_simulink' ) ;
    set_param( 'schema_simulink', 'StopTime', num2str( t( end ) ) ) ;
    sim( 'schema_simulink' ) ;
  
    ystar( i, 1 ) = h2_h3out.Data( end, 1 ) ;
    % datele de iesire ale lui h2
    ystar( i, 2 ) = h2_h3out.Data( end, 2 ) ;
    % datele de iesire ale lui h3
end

ustarr = [ 1 2 4 ] ;

for i = 1 : 3
    u1in = timeseries( 0 .* double( t >= 0 ) .', t ) ;
    u2in = timeseries( ustarr( i ) .* double( t >= 0 ) .', t ) ;
    
    load_system( 'schema_simulink_tema2' ) ;
    set_param( 'schema_simulink_tema2', 'StopTime', num2str( t( end ) ) ) ;
    sim( 'schema_simulink_tema2' ) ;
  
    xstar( i, 1 ) = x.Data( end, 1 ) ;
    xstar( i, 2 ) = x.Data( end, 2 ) ;
    xstar( i, 3 ) = x.Data( end, 3 ) ;
    xstar( i, 4 ) = x.Data( end, 4 ) ;
    xstar( i, 5 ) = x.Data( end, 5 ) ;
end

n = 3 ;
A = cell( n, 1 ) ; 
B = cell( n, 1 ) ; 
C = cell( n, 1 ) ; 
D = cell( n, 1 ) ;
[ A{ 1 }, B{ 1 }, C{ 1 }, D{ 1 } ] = linmod( 'schema_simulink_pini', xstar( 1, : ), [ 0 ; ustarr( 1 ) ] ) ; 

% Prima liniarizare
u1 = [ zeros( length( t ), 1 ) ustar( 3 ) * ones( length( t ), 1 ) ] ; 
V1 = lsim( ss( A{ 1 }, B{ 1 }, C{ 1 }, D{ 1 } ), ( u1 - [ zeros( length( t ), 1 ) ustar( 3 ) * ones( length( t ), 1 ) ] ), t', -xstar( 1, : ) ) + [ ystar( 3, 1 ) * ones( length( t ), 1 ) ystar( 3, 2 ) * ones( length( t ), 1 ) ] ; 

figure
grid on ;
hold on ;
plot( h2_h3out.Time, h2_h3out.Data, 'm' ) ;
hold on ;
plot( t, V1, 'y' ) ;
legend( 'neliniar - h2', 'neliniar - h3', 'liniar - h2', 'liniar - h3' ) ;
title( 'Ustar = 1' ) ;


[ A{ 2 }, B{ 2 }, C{ 2 }, D{ 2 } ] = linmod( 'schema_simulink_pini', xstar( 2, : ), [ 0 ; ustar( 2 ) ] ) ; 

% A doua liniarizare
u2 = [ zeros( length( t ), 1 ) ustar( 4 ) * ones( length( t ), 1 ) ] ; 
V2 = lsim( ss( A{ 2 }, B{ 2 }, C{ 2 }, D{ 2 } ), ( u2 - [ zeros( length( t ), 1 ) ustar( 4 ) * ones( length( t ), 1 ) ] ), t', -xstar( 2, : ) ) + [ ystar( 4, 1 ) * ones( length( t ), 1 ) ystar( 4, 2 ) * ones( length( t ), 1 ) ] ; 

figure
plot( h2_h3out.Time, h2_h3out.Data, 'y' ) ; 
hold on ;
plot( t, V2, 'g' ) ;
title( 'Ustar = 2' ) ;
legend( 'neliniar - h2', 'neliniar - h3', 'liniar - h2', 'liniar - h3' ) ;


[ A{ 3 }, B{ 3 }, C{ 3 }, D{ 3 } ] = linmod( 'schema_simulink_pini', xstar( 3, : ), [ 0 ; ustarr( 3 ) ] ) ; 

% A treia liniarizare
u3 = [ zeros( length( t ), 1 ) ustar( 10 ) * ones( length( t ), 1 ) ] ; 
V3 = lsim( ss( A{ 3 }, B{ 3 }, C{ 3 }, D{ 3 } ), ( u3 - [ zeros( length( t ), 1 ) ustar( 10 ) * ones( length( t ), 1 ) ] ), t', -xstar( 3, : ) ) + [ ystar( 10, 1 ) * ones( length( t ), 1 ) ystar( 10, 2 ) * ones( length( t ), 1 ) ] ; 

figure
plot( h2_h3out.Time, h2_h3out.Data, 'm' ) ; 
hold on ;
plot( t, V3, 'r' ) ;
title( 'Ustar = 4' ) ;
legend( 'neliniar - h2', 'neliniar - h3', 'liniar - h2', 'liniar - h3' ) ;


