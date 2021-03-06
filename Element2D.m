classdef Element2D
    %ELEMENT2D A class modeling a 2D finite element (FEA).
    %   Models a triangular finite element in 2-dimensions. Contains
    %   element properties: a_a, c_e, f_e, and h_e. Also contains a method 
    %   for generating an elemental stiffness matrix, K_e, from the 
    %   elemental properties and storing it as a dependent property. In
    %   additon, the elemental force vector, f_e, is generated using a 
    %   method and stored, similar to K_e.
    
    properties
        a_e
        f_e
        d1_e
        d2_e
        d3_e        
        area
        alpha
        beta
        gamma
        boundary
    end
    
    properties (Dependent)
        K_e
        F_e
        Q_e
    end
    
    methods
        function element = Element2D(a, f, n, p, t, e)
            %CONSTRUCTOR Constructor for element class.
            %   Assigns parameters to class properties.
            element.a_e(1,1) = a(1,1);
            element.a_e(1,2) = a(1,2);
            element.a_e(2,1) = a(2,1);
            element.a_e(2,2) = a(2,2);
            element.f_e = f;
           
            %Does it have a boundary face?
            counter = 0;
            for i = 1:size(e)
                for j = 1:3
                    if t(n,j) == e(i,1)
                        counter = counter + 1;
                    elseif t(n,j) == e(i,2)
                        counter = counter + 1;
                    end
                end
            end
            if counter == 2
                element.boundary = 1;
            else
                element.boundary = 0;
            end
            
            %Positions of each node as a coordinate list
            %Node 1
            element.d1_e = [p(t(n,1),1), p(t(n,1),2)]; %(x1,y1)
            %Node 2
            element.d2_e = [p(t(n,2),1), p(t(n,2),2)]; %(x2,y2)
            %Node 3
            element.d3_e = [p(t(n,3),1), p(t(n,3),2)]; %(x3,y3)
            
            %Create side lengths of triangle from distance formula
            sideA = sqrt((element.d1_e(1) - element.d2_e(1))^2 + (element.d1_e(2) - element.d2_e(2))^2);
            sideB = sqrt((element.d2_e(1) - element.d3_e(1))^2 + (element.d2_e(2) - element.d3_e(2))^2);
            sideC = sqrt((element.d3_e(1) - element.d1_e(1))^2 + (element.d3_e(2) - element.d1_e(2))^2);
            
            %Create area of triangle from Heron's formula
            half_peri = (sideA+sideB+sideC)/2;
            element.area = sqrt(half_peri*(half_peri-sideA)*(half_peri-sideB)*(half_peri-sideC));
            
            %Create inverse values for the elemental coefficient matrix
            element.alpha = [(element.d2_e(1)*element.d3_e(2)-element.d3_e(1)*element.d2_e(2));(element.d3_e(1)*element.d1_e(2)-element.d1_e(1)*element.d3_e(2));(element.d1_e(1)*element.d2_e(2)-element.d2_e(1)*element.d1_e(2))];
            element.beta = [(element.d2_e(2)-element.d3_e(2));(element.d3_e(2)-element.d1_e(2));(element.d1_e(2)-element.d2_e(2))];
            element.gamma = [-1*(element.d2_e(1)-element.d3_e(1));-1*(element.d3_e(1)-element.d1_e(1));-1*(element.d1_e(1)-element.d2_e(1))];
        end %end constructor
        
        function K_e = stiffness_matrix(element)
            %STIFFNESS_MATRIX Generates stiffness matrix for element class.
            %   Generates a stiffness matrix for tirangluar elements
            
            %Bringing it all together to generate the elemental stiffness matrix
            K_e = zeros(3,3);
            for i = 1:3
                for j= 1:3
                    K_e(i,j) = 1/(4*element.area)*(element.a_e(1,1)*element.beta(i)*element.beta(j)+element.a_e(2,2)*element.gamma(i)*element.gamma(j));
                end
            end
        end %end stiffness_matrix
        
        function F_e = force_vector(element)
            %FORCE_VECTOR Generates force vector for the element class.
            %   Generates a force vector for the element class.
            F_e = zeros(1,3);
            for i = 1:3
                F_e(i) = 1/3*element.f_e*element.area;
            end
        end % end force_vector
        
        %function Q_e = boundary_conditions(element)
            %BOUNDARY_CONDITIONS Generates a boundary condition vector for
            %the element class.
            %   Generates a boundary condition vector for the element
            %   class.
         %   Q_e = zeros(1,3);
          %  if element.boundary == 1
           %     for i = 1:3
            %    end
            %end
                    
                
        %end
    end %end methods
    
end %end class

