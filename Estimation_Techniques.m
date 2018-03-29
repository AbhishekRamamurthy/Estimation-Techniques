W_T=[];
% Total number of Simulation in runs
for m=1:1000
    % Total runs for Each Simulation N
    N=m;
    W_T_I=[];
    for i=1:N
        Wi=0;
        % Initializing Wi to 0
        % Wi will have total time for 10 frames
        
        %Array of Wi
        % Frame inter Arrival time for 10 Frames
        A_I=exprnd(0.5,[1 10]);
        
        % Inidvidual frame arrival time
        I_F_A=A_I();
        TOA=0; % Count to keep track of Arrival time
        for j=1:10
            
            I_F_A(j)=TOA+A_I(j);
            TOA=TOA+A_I(j);
        end
        
        % Inidvidual Frame Service time for 10 Frames
        S_T= exprnd(1,[1 10]);
        %Total Time frame spends at AP after arrival
        TTF=A_I();
        for k=1:10
            Total=0;
            %1) Total time Frame spends TOA + S_T
            %   Without Queuing delay
            %2) With Queuing delay TOA(k-1)-TOA(k)+ST
            if(k==1)
                TTF(k)=I_F_A(k)+S_T(k);
            else
                %if TOA of 1st Frame is greater than
                %inter arrival time of 2nd Frame no delay
                if(I_F_A(k) >= TTF(k-1))
                    
                    TTF(k)=I_F_A(k)+S_T(k);
                else
                    %if 2nd Frame arrives before first frame
                    %gets serviced
                    TTF(k)=TTF(k-1)-I_F_A(k)+S_T(k);
                end
            end
            Wi=Wi+TTF(k);
            W_T_I(i)=Wi;
        end
    end
    W_T(m)=0;
    %for l=1:N
    
    %	W_T(m)=W_T(m)+W_T_I(l);
    %end
    W_T(m)=mean(W_T_I);
    CI(m) =((2*1.645 *(std(W_T_I) / sqrt(m))/mean(W_T_I)));
end

figure(1);
subplot(2,1,1);
hold on;
plot(W_T);
xlabel('Simulation Runs');
ylabel('Raw Estimator outcomes');

subplot (2,1,2);
plot(CI);
xlabel('Simulation Runs');
ylabel('Confidence Interval');
hold on;
% Estimator 1
W_T_Avg=mean(W_T);
Z_BAR=[];
L=0;
count=0;
for m=1:1000
    % Total runs for Each Simulation N
    N1=m;
    for r=1:N1
        %service time for 10 packets
        S_K= exprnd(1,[1 10]);
        Yi=0;
        for j=1:10
            %total time for servicing 10 packets
            Yi=Yi+S_K(j);
        end
        %store the values of 10 packets servicing
        Y_I(r)=Yi;
    end
    Ybar=mean(Y_I);
    E_Y=10; % Given in problem E[Y]=p/mu ;p=10 m=1
    for t=1:N1
        
        cprime=(1/N1)*(W_T(t)-W_T_Avg)*(Y_I(t)-Ybar);
    end
    cprime=-1*(cprime/(var(Y_I)));
    Z_BAR(m)=W_T_Avg+ cprime*(Ybar-10);
    CI(m) =((2*1.645 *(std(Z_BAR) / sqrt(m))/mean(Z_BAR)));
end
subplot(2,1,1);
plot(Z_BAR);
hold on;
subplot (2,1,2);
plot(CI);
hold on;
%Estimator 2

H=[];
for m=1:1000
    
    for i=1:m
        %service time for frames with mu=1
        S_K_2=exprnd(1,[1 10]);
        
        %arrival time for frames with mu 0.5
        A_I_2=exprnd(0.5,[1 10]);
        t=0;
        
        %cummulative arrival time
        for j=1:10
            
            t=t+A_I_2(j);
            TOA_2(j)=t;
        end
        I_A=0;
        %inter arrival time summation Sum(I(k+1)-I(k))
        for n=1:9
            
            I_A=I_A+TOA_2(n+1)-TOA_2(n);
        end
        
        %service time
        sk=0;
        for k=1:10
            
            sk=sk+S_K_2(k);
        end
        
        Q(i)=sk-I_A;
    end
    
    Qbar=mean(Q);
    
    E_Q=10-(10-1)/2; % Given 10/1-(10-1)/2
    for t=1:m
        
        cprime=(1/m)*(W_T(t)-W_T_Avg)*(Q(t)-Qbar);
    end
    cprime=-1*(cprime/(var(Q)));
    
    H(m)=W_T_Avg+ cprime*(Qbar-E_Q);
    CI(m) =((2*1.645 *(std(H) / sqrt(m))/mean(H)));
end
subplot(2,1,1);
plot(H);
hold on;
subplot (2,1,2);
plot(CI);
hold on;

%Estimator 3
L_I=[];
for m=1:1000
	
	for i=1:m	
		%service time for frames with mu=1
		S_K_3=exprnd(1,[1 10]);
		
		%arrival time for frames with mu 0.5
		A_I_3=exprnd(0.5,[1 10]);
		t=0;
		
		%cummulative arrival time
		for j=1:10
			
			t=t+A_I_3(j);
			TOA_3(j)=t;
		end
		
		%totoal time frame spends in system
		
		for  c=1:10
			
			if(c==1) 
				%first frame no queue delay
				TTF_3(c)= A_I_3(c)+S_K_3(c);
				else	
					if(TOA_3(c)>=TTF_3(c-1))
						%2nd Frame if arrived after servicing of first frame
						%experiences no queuing delay
						TTF_3(c)=A_I_3(c)+S_K_3(c);
					else
						%if 2nd frame arrives before servicing frist frame
						%queuing delay should be considered
						TTF_3(c)=TTF_3(c-1)-A_I_3(c)+S_K_3(c);
					end
			end					
        end
		%total packets in system Queue when frame K arrived 
		
		for d=2:10
		Nk=0;
			for e=1:d-1
				if(TOA_3(d)<TTF_3(e))
				
					Nk=Nk+1;
				end
            end
            if(d==2) 
                l_i(i)=(Nk+1)*S_K_3(d);
            else
                l_i(i)=l_i(i)+(Nk+1)*S_K_3(d);
            end 
		end
	end
	L_I(m)=mean(l_i);
    CI(m) =((2*1.645 *(std(l_i) / sqrt(m))/mean(l_i)));
end
subplot(2,1,1);
plot(L_I);
hold off;
subplot (2,1,2);
plot(CI);
hold off;