clc ;
clear all ;
close all ;

% Valori date
Tema_MS

% Valori initiale 1
h1 = 0 ; 
h2 = 0 ; 
h3 = 0 ; 
h4 = 0 ; 
h  = 0 ;

u = [ 0 0.5 1 2 2.3 2.4 2.7 3 3.5 4 ] ;

for i = 1 : length( u )
    [ xstar, ustar, ystar, dx ] = trim( 'schema_simulink_pini' , [], [ u( i ) ; 2 ], [], [], 1, [] ) ;
    h2_1( i ) = ystar( 1 ) ;
    h3_1( i ) = ystar( 2 ) ;
end

figure ;
plot( h2_1 ) ;
hold on
plot( h3_1 ) ;
title( 'Caracteristica statica( trim 1 )' ) ;


% Valori initiale 2
h1 = 2 * kp ; 
h2 = 3 * kp ; 
h3 = 4 * kp ; 
h4 = 5 * kp ;
h  = 6 * kp ;

u = [ 0 0.5 1 2 2.3 2.4 2.7 3 3.5 4 ] ;

for i = 1 : length( u )
    [ xstar, ustar, ystar, dx ] = trim( 'schema_simulink_pini' , [], [ u( i ) ; 2 ], [], [], 1, [] ) ;
    h2_1( i ) = ystar( 1 ) ;
    h3_1( i ) = ystar( 2 ) ;
end

figure ;
plot( h2_1 ) ;
hold on
plot( h3_1 ) ;
title( 'Caracteristica statica( trim 2 )' ) ;


% Valori initiale 3
h1 = 10 * kp ; 
h2 =  5 * kp ; 
h3 =  7 * kp ; 
h4 =  5 * kp ;
h  = 12 * kp ;

u = [ 0 0.5 1 2 2.3 2.4 2.7 3 3.5 4 ] ;

for i = 1 : length( u )
    [ xstar, ustar, ystar, dx ] = trim( 'schema_simulink_pini' , [], [ u( i ) ; 2 ], [], [], [], [] ) ;
    h2_1( i ) = ystar( 1 ) ;
    h3_1( i ) = ystar( 2 ) ;
end

figure ;
plot( h2_1 ) ;
hold on
plot( h3_1 ) ;
title( 'Caracteristica statica( trim 3 )' ) ; 
