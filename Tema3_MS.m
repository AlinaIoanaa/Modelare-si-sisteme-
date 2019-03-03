clc ;
clear all ;

Tema2_MS
close all ;

a = -0.5 ; 
% termen de amortizare , trebuie sa f i e negativ pentru

T = 100 ; 
timp = linspace(0 , T, 1e4 ) ;
u = 2.25 * double( timp <= 30 ) + 0.47 * double( ( 30 < timp ) .* ( timp <= 70 ) ) + 0.50 * double( ( 70 < timp ) .* ( timp <= T ) ) ;

sigma = 3 * double( timp <= 30 ) + 1 * double( ( 30 < timp ) .* ( timp <= 70 ) ) + 2 * double( ( 70 < timp ) .* ( timp <= T ) ) ;

clear( 'ustar' ) ;
clear( 'ustarr' ) ;
ustar = { 1.15 1.5 2.25 } ;
clear( 'A' ) ;
clear( 'B' ) ;
clear( 'C' ) ;
clear( 'D' ) ;
clear( 'xstar' ) ;
clear( 'ystar' ) ;

load_system( 'schema_simulink' ) ;

for i = 1 : 3
    
    set_param( 'schema_simulink', 'StopTime', num2str( timp( end ) ) ) ;
    
    u1in = timeseries( 0 .* double( timp >= 0 ) .', timp ) ;
    u2in = timeseries( ustar{ i } .* double( timp >= 0 ) .', timp ) ;
    
    sim( 'schema_simulink' ) ;
    
%     xstar( i, 1 ) = x.Data( end, 1 ) ;
%     xstar( i, 2 ) = x.Data( end, 2 ) ;
%     xstar( i, 3 ) = x.Data( end, 3 ) ;
%     xstar( i, 4 ) = x.Data( end, 4 ) ;
%     xstar( i, 5 ) = x.Data( end, 5 ) ;

    xstar{ i } = x.Data( end, : ) ;
    
    ystar{ i } = [ h2_h3out.Data( end, 1 ) h2_h3out.Data( end, 2 ) ] ;
    
    [ A{ i }, B{ i }, C{ i }, D{ i } ] = linmod( 'schema_simulink_pini', xstar{ i }, [ ustar{ i } ; 0 ]' ) ;
end

clear( 'xinitial' ) ;
xinitial = [0 0 0 0 0 ] ;

alternanta = find( ( diff( sigma ) ) ~= 0 ) ;
alternanta = [ 1 alternanta length( timp ) + 1 ] ;

clear( 'uCurent' ) ;
clear( 'ylin' ) ;
clear( 'xlin' ) ;
clear( 'linCurenta' ) ;
clear( 'timpCurent' ) ;
clear( '~' ) ;
clear( 'y_lpp' ) ;

y_lpp = [] ;


for i = 1 : length ( alternanta ) - 1 
    
    linCurenta = sigma( alternanta( i ) + 1 ) ;
    timpCurent = timp( alternanta( i ) : alternanta( i + 1 ) - 1 ) - timp( alternanta( i ) ) ; 
    uCurent = u( alternanta( i ) : alternanta( i + 1 ) - 1 ) ;
    
	[ ylin, ~, xlin ] = lsim( ss( A{ linCurenta }, B{ linCurenta }, C{ linCurenta }, D{ linCurenta } ),...
        [ uCurent ; zeros( length( uCurent ), 1 )' ] - [ ustar{ i } * ones( length( uCurent ), 1 )' ; zeros( length( uCurent ), 1 )' ], timpCurent, xinitial - xstar{ linCurenta } ) ;
    
    y_lpp = [ y_lpp; ylin + repmat( ystar{ linCurenta }', 1, length( ylin ) )' ] ; 
end

load_system( 'schema_simulink' ) ;
set_param( 'schema_simulink', 'StopTime', num2str( timp( end ) ) ) ;
    
u1in = timeseries( u', timp ) ;
   
sim( 'schema_simulink' ) ;

figure
grid on
hold on
plot( h2_h3out.Time( :, 1 ), h2_h3out.Data( :, 1 ), 'm' ) 
plot( timp, y_lpp( :, 1 ), 'y' )
legend( 'timp', 'y_lpp' )
title( 'H2' ) ;

figure
grid on
hold on
plot( h2_h3out.Time( :, 1 ), h2_h3out.Data( :, 2 ), 'm' ) 
plot( timp, y_lpp( :, 2 ), 'y' )
legend( 'timp', 'y_lpp' )
title( 'H3' ) ;