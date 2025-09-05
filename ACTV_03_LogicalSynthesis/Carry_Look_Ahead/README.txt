###### O Fluxo para execução da síntese foi automatizado com o uso do Makefile e está descrito na seguinte etapa (equivalente entre síntese física e síntese lógica):


em /scripts:

## Executar a síntese
make run_synth FREQ_MHZ=<valor_da_frequencia_desejada_em_MHZ>

## Executar a simulação pós-síntese
make compile_sdf FREQ_MHZ=<valor_da_frequencia_desejada_em_MHZ>
make sim_pos_syn FREQ_MHZ=<valor_da_frequencia_desejada_em_MHZ>

* Caso não seja informado o valor de FREQ_MHZ, o fluxo será realizado com a frequência de 500MHz.,
** Para a simulação pós síntese, deve-se alterar manualmente no testbench o arquivo SDF.X a ser utilizado


## Para executar a simulação pré-síntese, deve-se fazer o seguinte:

entrar em /backend/synthesis/scripts
executar make sim

