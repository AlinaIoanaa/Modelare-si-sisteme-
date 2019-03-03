clc ;
clear all ;
close all ;

Tema2_MS

ystarr( :, 1 ) = [ ystar( 3, 1 ) ystar( 4, 1 ) ystar( 10, 1 ) ] ;
ystarr( :, 2 ) = [ ystar( 3, 2 ) ystar( 4, 2 ) ystar( 10, 2 ) ] ;

% Caracteristica statica
figure ;
grid on ;
hold on ;
plot( ustarr, ystarr( :, 1 ), 'm*-' ) ;
hold on ;
plot( ustarr, ystarr( :, 2 ), 'y*-' ) ;
hold on ;

V( :, 1 ) = [ V1( end, 1 ) V2( end, 1 ) V3( end, 1 ) ] ;
V( :, 2 ) = [ V1( end, 2 ) V2( end, 2 ) V3( end, 2 ) ] ;

plot( ustarr, V( :, 1 ), 'r*-' ) ;
hold on
plot( ustarr, V( :, 2 ), 'g*-' ) ;
legend( 'h2', 'h3', 'caract. liniara - h2', 'caract. liniara - h3' ) ;
title( 'Caracteristica statica sistem liniarizat + sistem neliniarizat' ) ;

% h)
figure
for j = 1 : 3
    i = 1 ;        
    
    u1in = timeseries( 0 .* double( t >= 0 ) .', t ) ;
    u2in = timeseries( ustarr( j ) .* double( t >= 0 ) .', t ) ;
    
    load_system( 'schema_simulink_tema2' ) ;
    set_param( 'schema_simulink_tema2', 'StopTime', num2str( t( end ) ) ) ;
    sim( 'schema_simulink_tema2' ) ;
  
    % Xstar
    xstar( j, 1 ) = x.Data( end, 1 ) ;
    xstar( j, 2 ) = x.Data( end, 2 ) ;
    xstar( j, 3 ) = x.Data( end, 3 ) ;
    xstar( j, 4 ) = x.Data( end, 4 ) ;
    xstar( j, 5 ) = x.Data( end, 5 ) ;
    
    % linmod
    [ A{ j }, B{ j }, C{ j }, D{ j } ] = linmod( 'schema_simulink_pini', xstar( j, : ), [ 0 ; ustarr( j ) ] ) ;
    sim( 'schema_simulink' ) ;
    sys = ss( A{ j }, B{ j }, C{ j }, D{ j } ) ;
    
    for u = 0 : 0.1 : 2.5 
        u1 = [ zeros( length( t ), 1 ) u * ones( length( t ), 1 ) ] ; 
        V = lsim( sys, ( u1 - [ zeros( length( t ), 1 ) ustarr( j ) * ones( length( t ), 1 ) ] ), t', -xstar( j, : ) ) + [ ystarr( j, 1 ) * ones( length( t ), 1 ) ystarr( j, 2 ) * ones( length( t ), 1 ) ] ;
        error( i ) = norm( ystarr( j ) - V( end ) ) / norm( ystarr( j ) ) ;
        i = i + 1 ;
    end
    
    u = 0 : 0.1 : 2.5 ;
    k = 1 : 1 : i - 1 ;
    if j == 1
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'm--' ) ;
        hold on
        plot( u, error, 'm*-' ) ;
        hold on
    end
    if j == 2
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'r--' ) ;
        hold on
        plot( u, error, 'r*-' ) ;
        hold on
    end
    if j == 3
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'y--' ) ;
        hold on
        plot( u, error, 'y*-' ) ;
        hold off
    end
end

legend( 'Qstar1 - polyfit', 'Qstar1', 'Qstar2 - polyfit', 'Qstar2', 'Qstar3 - polyfit', 'Qstar3', 'eroare minima' ) ;
title( 'Iesirile sistemelor' ) ; 

% i)
figure
for j = 1 : 3
    i = 1 ;        
    
    u1in = timeseries( 0 .* double( t >= 0 ) .', t ) ;
    u2in = timeseries( ustarr( j ) .* double( t >= 0 ) .', t ) ;
    
    load_system( 'schema_simulink_tema2' ) ;
    set_param( 'schema_simulink_tema2', 'StopTime', num2str( t( end ) ) ) ;
    sim( 'schema_simulink_tema2' ) ;
  
    % Xstar
    xstar( j, 1 ) = x.Data( end, 1 ) ;
    xstar( j, 2 ) = x.Data( end, 2 ) ;
    xstar( j, 3 ) = x.Data( end, 3 ) ;
    xstar( j, 4 ) = x.Data( end, 4 ) ;
    xstar( j, 5 ) = x.Data( end, 5 ) ;
    
    % linmod
    [ A{ j }, B{ j }, C{ j }, D{ j } ] = linmod( 'schema_simulink_pini', xstar( j, : ), [ 0 ; ustarr( j ) ] ) ;
    sim( 'schema_simulink' ) ;
    sys = ss( A{ j }, B{ j }, C{ j }, D{ j } ) ;
    
    for u = 0 : 0.1 : 2.5 
        u1 = [ zeros( length( t ), 1 ) u * ones( length( t ), 1 ) ] ; 
        V = lsim( sys, ( u1 - [ zeros( length( t ), 1 ) ustarr( j ) * ones( length( t ), 1 ) ] ), t', -xstar( j, : ) ) + [ ystarr( j, 1 ) * ones( length( t ), 1 ) ystarr( j, 2 ) * ones( length( t ), 1 ) ] ;
        error( i ) = norm( ystarr( j ) - V( end ) ) / norm( ystarr( j ) ) ;
        i = i + 1 ;
    end
    
    u = 0 : 0.1 : 2.5 ;
    k = 1 : 1 : i - 1 ;
    if j == 1
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'm--' ) ;
        hold on
        plot( u, error, 'm*-' ) ;
        hold on
    end
    if j == 2
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'r--' ) ;
        hold on
        plot( u, error, 'r*-' ) ;
        hold on
    end
    if j == 3
        p = polyfit( k, error, 10 ) ;
        y = polyval( p, k ) ;
        plot( u, y, 'y--' ) ;
        hold on
        plot( u, error, 'y*-' ) ;
        hold on
    end
    M( j ) = min( error ) ; 
    % [ x, y ] = findpeaks( M ) ; 
end

minim = [ 1.63332547725115 1.31222330080327 0.991121124355502 0.670018947907622 0.348916771459741 0.0278145950118610 0.293287581435963 0.509849318480444 0.349295114076073 0.188740909671702 0.0281867052673374 0.132367499137030 0.292921703541291 0.453475907945660 0.533311090895480 0.453044178435699 0.372777265975920 0.292510353516139 0.212243441056359 0.131976528596574 0.0517096161368026 0.0285572963229856 0.108824208782766 0.189091121242119 0.269358033702108 0.349624946161887 ] ;
plot( u, minim, 'k*-' ) ;
hold off 

legend( 'Qstar1 - polyfit', 'Qstar1', 'Qstar2 - polyfit', 'Qstar2', 'Qstar3 - polyfit', 'Qstar3', 'Eroare minima' ) ;
title( 'Eroare minima' ) ; 


% Qstar1 -> [ 1.63332547725115, 0.293287581435963 ]
% Qstar2 -> [ 0.50984931848044, 0.453475907945660 ]
% Qstar3 -> [ 0.53331109089548, 0.349624946161887 ] 