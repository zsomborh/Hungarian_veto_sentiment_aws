rm(list = ls())

setwd('C:/Users/T450s/Desktop/programming/git/sentiment_analysis-medium')
library(rvest)
library(data.table)


# Speicfy links of articles -----------------------------------------------


#links from origo
origo_urls<-
c('https://www.origo.hu/itthon/20201116-orban-viktor-magyarorszag-megvetozza-az-unios-budzset-es-a-helyreallitasi-alapot.html',
'https://www.origo.hu/itthon/20201116-az-europai-koltsegvetes-vetojat-rakenyszeritik-magyarorszagra.html',
'https://www.origo.hu/itthon/20201117-bajkai-a-magyar-kormany-vetozni-fogja-az-eu-kovetkezo-koltsegveteset.html',
'https://www.origo.hu/itthon/20201117-gyorgy-laszlo-brusszeli-veto.html',
'https://www.origo.hu/itthon/20201117-a-fideszkdnp-epkepviselocsoportja-tamogatja-a-kormanynak-a-magyar-emberek-vedelmeben-hozott-donteset.html',
'https://www.origo.hu/itthon/20201118-orban-viktor-a-kormany-az-unios-szerzodesekben-garantalt-jogaval-elve-vetozta-meg.html',
'https://www.origo.hu/nagyvilag/20201118-koltsegvetesi-vita-migracio-es-jogallamisag-hogyan-fonodott-ossze.html',
'https://www.origo.hu/itthon/20201118-donald-tusk-sajat-magat-cafolja.html',
'https://www.origo.hu/nagyvilag/20201118-nem-lehet-feltetelekhez-kotni-a-tamogatast-a-jarvanyhelyzetben.html',
'https://www.origo.hu/itthon/20201119-soros-magyarorszag-es-lengyelorszag-ellen-fel-kell-lepni.html',
'https://www.origo.hu/itthon/percrolpercre/20201119-kormanyinfo-pp-2020-november-19.html',
'https://www.origo.hu/nagyvilag/20201119-az-olasz-testverek-kiallnak-magyarorszag-mellett.html',
'https://www.origo.hu/nagyvilag/20201119-morawiecki-igen-az-eura-nem-a-jogallamisag-onkenyes-ertekelesere.html',
'https://www.origo.hu/itthon/20201119-penzugyi-zsarolast-es-politikai-buntetest-alkalmaznak-az-unios-intezmenyek.html',
'https://www.origo.hu/itthon/20201119-varga-judit-magyarorszag-soha-nem-engedi-hogy-ideologiai-alapon-zsaroljak.html',
'https://www.origo.hu/itthon/20201119-eucsucs-targyalasok.html',
'https://www.origo.hu/itthon/percrolpercre/20201120-orban-viktor-radiointerju-pp-2020-november-20.html',
'https://www.origo.hu/nagyvilag/20201120-alapjogokert-kozpont-sok-teves-informacio-ovezi-a-tobbeves-penzugyi-keretrol.html',
'https://www.origo.hu/itthon/20201122-deutsch-europai-unios-onkeny-valthatja-a-korabbi-kommunista-onkenyt.html',
'https://www.origo.hu/itthon/20201123-soros-europara-akarja-kenyszeriteni-a-bevadorlast.html',
'https://www.origo.hu/nagyvilag/20201125-deutsch-tamas-szerint-szanalmas-cicaharc-amit-az-europai-parlament-csinal.html',
'https://www.origo.hu/nagyvilag/20201125-kovacs-zoltan-olaszorszagnak-nem-magyarorszag-hanem-az-eu-okoz-kart.html',
'https://www.origo.hu/itthon/20201126-orban-viktor-mateusz-morawiecki-tajekoztato-2020-november-26.html',
'https://www.origo.hu/itthon/percrolpercre/20201127-orban-viktor-radiointerju-pp-2020-november-27.html',
'https://www.origo.hu/itthon/20201130-frank-furedi-magyarorszagnak-es-lengyelorszagnak-van-igaza-az-unios-vitaban.html',
'https://www.origo.hu/itthon/20201130-orszaggyules-napirend-elott-2020-november-30.html',
'https://www.origo.hu/nagyvilag/20201130-varso-es-budapest-a-nemet-soros-euelnokseg-uj-javaslataira-var.html')

index_urls <- 
c(
'https://index.hu/belfold/2020/12/01/lengyelorszag_magyarorszag_europai_unio_koltsegvetes_piotr_muller/',
'https://index.hu/belfold/2020/11/30/orban_viktor_varso_lengyelorszag_miniszterelnok_munkaertekezlet_mateusz_morawiecki_europai_unio_talalkozo_koltsegvetes/',
'https://index.hu/gazdasag/2020/11/30/unios_mentocsomag_orban_viktor/',
'https://index.hu/kulfold/2020/11/27/lengyelorszag_unios_veto/',
'https://index.hu/belfold/2020/11/26/orban_viktor_veto_momentum_demokratikus_koalicio/',
'https://index.hu/kulfold/2020/11/26/orban_viktor_veto_eu_magyarorszag_lengyelorszag/',
'https://index.hu/belfold/2020/11/26/kormanyinfo/',
'https://index.hu/belfold/2020/11/26/ma_budapesten_egyeztet_az_unios_vetorol_lengyel_miniszterelnok/',
'https://index.hu/velemeny/2020/11/24/veto_a_jogallamra_-_unios_koltsegvetes_uj_felallasban/',
'https://index.hu/kulfold/2020/11/24/veto_eu_koltsegvetes/',
'https://index.hu/belfold/2020/11/22/orban_viktor_koronavirus_manfred_weber/',
'https://index.hu/belfold/2020/11/22/deutch_tamas_europai_unio_bevandorlas/',
'https://index.hu/belfold/2020/11/21/orban_viktor_unios_koltsegvetesi_vetoja_ellen_indit_peticiot_dobrev_klara/',
'https://index.hu/kulfold/2020/11/20/varso_kompromisszumot_remel_eu_tamogatasok_es_a_jogallamisag_kerdeseben/',
'https://index.hu/gazdasag/2020/11/20/orban_unios_forrasok_jogallamisagi_mechanizmus/',
'https://index.hu/kulfold/2020/11/20/szlovakia_targyalasok_visegradi_negyek_veto/',
'https://index.hu/belfold/2020/11/20/orban_viktor/',
'https://index.hu/kulfold/2020/11/20/koronavirus_charles_michel/',
'https://index.hu/kulfold/2020/11/19/ora_indul_megkezdodott_az_unios_idegjatek/',
'https://index.hu/kulfold/2020/11/19/soros_europanak_fel_kell_allnia_magyarorszaggal_es_lengyelorszaggal_szemben/',
'https://index.hu/kulfold/2020/11/19/szlovakia_veto_eu-koltsegvetes/',
'https://index.hu/kulfold/2020/11/19/lengyelorszag_veto_europai_unio/',
'https://index.hu/belfold/2020/11/19/eu_magyarorszag_lengyelorszag_veto_jogallamisagi_mechanizmus_gazdasagelenkito_csomag/',
'https://index.hu/kulfold/2020/11/17/nemet_miniszter_magyarorszag_lengyelorszag_veto/',
'https://index.hu/tudomany/til/2020/11/17/koztarsasagokat_tartott_eletben_de_orszagokat_is_romba_dontott_a_veto/',
'https://index.hu/belfold/2020/11/17/eu-veto/',
'https://index.hu/kulfold/2020/11/17/eu-diplomata_meg_csak_teszteltuk_a_magyarokat/',
'https://index.hu/gazdasag/2020/11/17/magyarorrszag_forintarfolyam_veto/',
'https://index.hu/kulfold/2020/11/16/vargajudit_eu_koltsegvetes_veto/',
'https://index.hu/kulfold/2020/11/16/veto_lengyel_kormanyszovivo_europai_unio/',
'https://index.hu/velemeny/2020/11/16/veto_es_jogallamisag_-_ki_kapja_felre_elobb_a_kormanyt_brusszelben/',
'https://index.hu/gazdasag/2020/11/16/veto_europai_unio_orban_viktor/',
'https://index.hu/belfold/2020/11/16/wass_alberttel_europart/',
'https://index.hu/belfold/2020/11/16/orban_viktor_europai_unio_koltsegvetes_veto/'
)

twentyfour_urls <- c(
    'https://24.hu/fn/gazdasag/2020/11/16/orban-veto-eu-koltsegvetes/',
    'https://24.hu/kulfold/2020/11/16/unio-veto-jogallam-helyreallitasi-alap-orban/',
    'https://24.hu/kulfold/2020/11/16/orban-veto-unios-koltsegvetes/',
    'https://24.hu/kulfold/2020/11/16/unios-koltsegvetes-veto-lehetosege-lengyelorszag-jogallamisag/',
    'https://24.hu/fn/gazdasag/2020/11/16/unios-koltsegvetes-magyarorszag-orban-viktor-veto/',
    'https://24.hu/belfold/2020/11/17/gulyas-gergely-a-jarvany-utan-jobb-lesz-magyarorszagon-mint-a-rendszervaltas-ota-barmikor/',
    'https://24.hu/belfold/2020/11/17/karacsony-gergely-unios-koltsegvetes-veto-europai-unio/',
    'https://24.hu/kulfold/2020/11/17/orban-eu-veto-megoldas/',
    'https://24.hu/kulfold/2020/11/18/orban-viktor-unios-koltsegvetes-veto-indoklas/',
    'https://24.hu/kulfold/2020/11/18/europai-unio-veto-orban-viktor-ellenzek-nyilatkozat/',
    'https://24.hu/kulfold/2020/11/18/orban-viktor-v4-ek-unios-veto-szlovakia/',
    'https://24.hu/kulfold/2020/11/18/ep-koltsegvetes-orban-weber-veto/',
    'https://24.hu/belfold/2020/11/19/kormanyinfo-2020-11-19-gulyas-gergely/',
    'https://24.hu/fn/gazdasag/2020/11/19/soros-eu-veto/',
    'https://24.hu/kulfold/2020/11/20/vetougy-orban-elutasitja-orban-erveit/',
    'https://24.hu/kulfold/2020/11/22/manfred-weber-orban-viktor-veto-epp-fidesz/',
    'https://24.hu/kulfold/2020/11/22/zdf-szatira-eu-veto-orban/',
    'https://24.hu/belfold/2020/11/23/szajer-a-vetorol-bayernak-a-jogallam-unios-onkeny/',
    'https://24.hu/fn/gazdasag/2020/11/23/orban-viktor-fules-gulyas/',
    'https://24.hu/kulfold/2020/11/24/unios-koltsegvetes-megallapodas-dontes/',
    'https://24.hu/kulfold/2020/11/25/deutsch-tamas-manfred-weber-ugy-ervel-mint-a-gestapo-es-az-avh/',
    'https://24.hu/kulfold/2020/11/27/visszafogott-nemet-kritika-erkezett-arra-hogy-a-fideszbol-legestapoztak-manfred-webert/',
    'https://24.hu/kulfold/2020/11/30/orban-viktor-varso-veto/'
)

fourfourfour_urls <- c(
    'https://444.hu/2020/12/01/a-magyar-es-a-lengyel-kormany-a-nemet-elnokseg-javaslataira-var-hogy-megoldodjon-a-veto-miatti-patthelyzet',
    'https://444.hu/2020/11/30/merkel-szerint-engedni-kell-a-magyar-es-lengyel-igenyeknek-valamennyit-mert-ilyen-a-politika',
    'https://444.hu/2020/11/27/mig-orban-vetoval-fenyeget-gozerovel-tervezi-a-kormany-a-penz-elkolteset',
    'https://444.hu/2020/11/27/orban-viktor-ketezerrel-tobb-korhazi-betegrol-beszelt-a-radioban-mint-amirol-eddig-tudtunk',
    'https://444.hu/2020/11/27/hosszu-harcra-keszul-orban-es-morawiecki-europa-tobbi-resze-ellen',
    'https://444.hu/2020/11/26/orban-morawiecki-talalkozo-nem-irunk-ala-semmit-amit-lengyelorszag-nem-fogad-el',
    'https://444.hu/2020/11/25/a-lengyel-szenatus-az-unios-koltsegvetes-vetojanak-visszaszoritasara-szolitotta-fel-a-kormanyt',
    'https://444.hu/2020/11/24/a-nemet-kulugyminiszter-szerint-napokon-belul-megallapodnak-az-unios-koltsegvetesrol',
    'https://444.hu/2020/11/22/manfred-weber-szerint-csak-a-jarvany-miatt-nem-zartak-meg-ki-a-fideszt-az-europai-neppartbol',
    'https://444.hu/2020/11/20/lengyelorszag-kompromisszumot-remel-az-eu-koltsevgetes-ugyeben',
    'https://444.hu/2020/11/20/mi-lett-a-szabadsagharccal-orban-hirtelen-sikerkent-ertekeli-hogy-az-orszag-25-milliard-euronyi-hitelt-vesz-fel',
    'https://444.hu/2020/11/20/merkel-elegedett-a-jogallamisaghoz-kotott-unios-koltsegvetessel-egyelore-nem-keresnek-mas-megoldasokat',
    'https://444.hu/2020/11/20/orban-szerint-aki-magyarorszagot-tamadja-a-veto-miatt-az-korrupt',
    'https://insighthungary.444.hu/2020/11/19/hungary-joins-poland-in-vetoing-18-trillion-eu-budget-and-coronavirus-relief-package',
    'https://444.hu/2020/11/19/varga-judit-a-belga-es-a-dan-jogallamisag-miatt-aggodott-amikor-megerositette-a-magyar-vetot',
    'https://444.hu/2020/11/19/szembe-kell-szegulni-magyarorszaggal-es-lengyelorszaggal-irja-soros-gyorgy',
    'https://444.hu/2020/11/19/lengyel-miniszterelnok-egy-ilyen-eu-nak-nincs-jovoje',
    'https://444.hu/2020/11/17/koroz-egy-otlet-hogyan-vaghatna-vissza-az-eu-orbaneknak',
    'https://444.hu/2020/11/16/minositett-tobbseggel-atment-a-jogallamisagi-mechanizmus',
    'https://444.hu/2020/11/16/merkel-es-az-eu-vezetoi-megvitatjak-hogyan-kezeljek-a-magyar-vetot',
    'https://444.hu/2020/11/16/most-durvul-el-igazan-a-magyar-es-a-lengyel-kerdes-europaban')

pestisracok_urls<- c(
    'https://pestisracok.hu/szijjarto-peter-2021-masodik-negyedevetol-emelkedhet-a-magyar-gazdasag-kapacitasa/',
    'https://pestisracok.hu/soros-utat-mutatott-brusszelnek-hogyan-jatssza-ki-a-lengyel-magyar-vetot-megis-johetnek-az-orokkotvenyek/',
    'https://pestisracok.hu/gyurcsany-ismet-elojott-legjobb-baratjaval-a-kettos-mercevel-amikor-fleto-batran-vetozott-volna-brusszelben-video/',
    'https://pestisracok.hu/brusszel-szerint-a-melegek-es-a-migransok-jogai-az-alapveto-jogok/',
    'https://pestisracok.hu/liberalis-ossztuz-a-magyar-es-lengyel-veto-ellen-az-ep-ben/',
    'https://pestisracok.hu/ossztuz-zudult-magyarorszagra-es-lengyelorszagra-miutan-megvetoztak-az-unio-zsarolasi-tervet/',
    'https://pestisracok.hu/elfogtak-a-xv-keruleti-ket-aldozatot-kovetelo-lakastuz-feltetelezett-elkovetojet/',
    'https://pestisracok.hu/a-szejm-is-tamogatja-a-lengyel-kormany-vetojat/',
    'https://pestisracok.hu/kovacs-zoltan-az-europai-koltsegvetes-vetojat-rakenyszeritik-magyarorszagra/',
    'https://pestisracok.hu/orban-viktor-magyarorszag-megvetozza-az-unios-budzset-es-a-helyreallitasi-alapot/',
    'https://pestisracok.hu/megvetozhatja-magyarorszag-a-heteves-unios-koltsegvetest/'
) 

# scrape the sites and saving data to RDS

origo_articles<- lapply(origo_urls,function(x){
  t<- read_html(x)
  article_text <- t %>% html_nodes('p') %>% html_text()
  return(article_text)
}
)

saveRDS(origo_articles, file= 'data/raw/origo_articles_list.rds')


index_articles <- lapply(index_urls,function(x){
  Sys.sleep(1) # sleep is set otherwise Index blocks me
    
  t<- read_html(x)
  article_text <- t %>% 
      html_nodes('.anti_xsl p , p+ p , div+ p') %>% 
      html_text()
  
  print(x) #this is just to keep track which url is processed
  
  return(article_text)
}
)

saveRDS(index_articles, file= 'data/raw/index_articles_list.rds')



twentyfour_articles <- lapply(twentyfour_urls,function(x){
    Sys.sleep(1) # sleep is set otherwise 24.hu blocks me
    t<- read_html(x)
    article_text <- t %>% html_nodes('.post-body p , p+ ul li') %>% html_text()
    print(x) #this is just to keep track which url is processed
    return(article_text)
}
)

saveRDS(twentyfour_articles, file= 'data/raw/twentyfour_articles_list.rds')


fourfourfour_articles <- lapply(fourfourfour_urls,function(x){
    Sys.sleep(1) # sleep is set otherwise 444 blocks me
    t<- read_html(x)
    article_text <- t %>% html_node('#content-main') %>% html_nodes('p') %>% html_text()
    article_text <- article_text[1:length(article_text)-1]
    print(x) #this is just to keep track which url is processed
    return(article_text)
}
)
 
saveRDS(fourfourfour_articles, file= 'data/raw/fourfourfour_articles_list.rds')


pestisracok_articles <- lapply(pestisracok_urls,function(x){
    t<- read_html(x)
    article_text <- unique(t %>% html_nodes('#content-area p , strong') %>% html_text())
    return(article_text)
}
)


saveRDS(pestisracok_articles, file= 'data/raw/pestisracok_articles_list.rds')