Download Anaconda Python, then activate python setup in Matlab core, create the virtual env jmatlab:

follow the instructions at https://am111.readthedocs.io/en/latest/jmatlab_install.html 
conda install juypter notebook

%% now we have matlab kernel in juypter notebook%%%

%%next get multiple kernel notebook%%

conda activate jmatlab
cd E:\PhD\Anaconda2\ANACONDA_2\package\jupyter_notebook\sos-notebook-master
python setup.py install
python -m sos_notebook.install

%%%now every new session, open anaconda prompt %%%

conda activate jmatlab
cd E:\PhD\Anaconda2\ANACONDA_2\package
jupyter notebook