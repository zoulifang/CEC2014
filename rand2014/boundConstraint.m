function vi=boundConstraint(vi,  ubounds, lbounds);

[NP, D] = size(vi);  % the population size and the problem's dimension

Vmin=repmat(lbounds,NP,D);
Vmax=repmat(ubounds,NP,D);

%% check the lower bound
pos = vi < Vmin;
vi(pos) = 2 .* Vmin(pos) - vi(pos);
pos_=vi(pos) > Vmax(pos);
vi(pos(pos_)) = Vmax(pos(pos_));

%% check the upper bound
pos = vi > Vmax;
vi(pos) = 2 .* Vmax(pos) - vi(pos);
pos_=vi(pos) < Vmin(pos);
vi(pos(pos_)) = Vmin(pos(pos_));