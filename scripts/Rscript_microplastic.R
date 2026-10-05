# Statistical analysis
# Manuscript: Occurrence and Morphological Characterization of Putative
# Microplastic Particles in Marine Organisms from the Coastal Region
# of Salvador, Bahia, Brazil
# R version: 4.6.1
# Script version: 1.0

# Packages
packages<-c("dplyr","tidyr","ggplot2","FSA","openxlsx","here")
for(p in packages){library(p,character.only=TRUE)}

# 1. FILES
data_file<-here("data","mp_data.csv")
figures_dir<-here("results","figures")
tables_dir<-here("results","tables")
if(!dir.exists(figures_dir)){dir.create(figures_dir,recursive=TRUE)}
if(!dir.exists(tables_dir)){dir.create(tables_dir,recursive=TRUE)}

# 2. IMPORT DATA
data<-read.csv(data_file,stringsAsFactors=FALSE,check.names=FALSE)
required<-c("Species","Nivel","Total","Floating","Decanted")
missing<-setdiff(required,names(data))
if(length(missing)>0){stop(paste("Missing columns:",paste(missing, collapse=", ")))}

# 3. DATA PREPARATION
data<-data%>%mutate(Level=factor(Nivel,levels=c("P.C.","S.C.","T.C."),
  labels=c("PC","SC","TC")),Total=as.numeric(Total),Floating=as.numeric(Floating),
  Decanted=as.numeric(Decanted))
if(any(is.na(data$Level))){stop("Unknown trophic-level value detected.")}
if(any(is.na(data[c("Total","Floating","Decanted")]))){
  stop("Missing values detected in analytical variables.")}
if(any(data$Floating+data$Decanted!=data$Total)){
  stop("Floating + Decanted does not equal Total.")}

# 4. DESCRIPTIVE STATISTICS
descriptive<-data%>%group_by(Level)%>%summarise(n=n(),Floating_median=median(Floating),
  Floating_Q1=quantile(Floating,0.25),Floating_Q3=quantile(Floating, 0.75),
  Decanted_median=median(Decanted),Decanted_Q1=quantile(Decanted,0.25),
  Decanted_Q3=quantile(Decanted,0.75),.groups="drop")%>%mutate(
  Floating_Median_IQR=sprintf("%.1f [%.1f–%.1f]",Floating_median,Floating_Q1,
  Floating_Q3),Decanted_Median_IQR=sprintf("%.1f [%.1f–%.1f]",Decanted_median,
  Decanted_Q1,Decanted_Q3))

# 5. KRUSKAL-WALLIS
kw_floating<-kruskal.test(Floating~Level,data=data)
kw_decanted<-kruskal.test(Decanted~Level,data=data)
kw_table<-data.frame(Fraction=c("Floating","Decanted"),
  H=c(unname(kw_floating$statistic),unname(kw_decanted$statistic)),
  df=c(unname(kw_floating$parameter),unname(kw_decanted$parameter)),
  p_value=c(kw_floating$p.value,kw_decanted$p.value))

# 6. DUNN POST-HOC
dunn_floating<-dunnTest(Floating~Level,data=data,method="bonferroni")$res
dunn_floating_table<-dunn_floating%>%transmute(Comparison,Z=round(Z,3),
  p_unadjusted=P.unadj,p_Bonferroni=P.adj)

# 7. DATA FOR BOXPLOT
box_data<-data%>%select(Level,Floating,Decanted)%>%pivot_longer(cols=c(Floating,
  Decanted),names_to="Fraction",values_to="Particles")%>%mutate(Fraction=factor(
  Fraction,levels=c("Floating","Decanted")))

# 8. FIGURE 1 — PARTICLE COUNTS
figure_theme<-theme_classic(base_size=12,base_family="Arial")+
  theme(axis.title=element_text(size=12,colour="black"),axis.text=element_text(
  size = 11,colour="black"),axis.line=element_line(linewidth=0.5,colour="black"),
  axis.ticks=element_line(linewidth=0.4,colour="black"),legend.position="top",
  legend.title=element_text(size=11),legend.text=element_text(size=10),
  legend.key=element_blank())
g_box<-ggplot(box_data,aes(x=Level,y=Particles,fill=Fraction))+
  geom_boxplot(position=position_dodge(width=0.70),width=0.55,
    linewidth=0.5,colour="black",outlier.shape=NA)+
  geom_point(position=position_jitterdodge(jitter.width=0.06,dodge.width=0.70),
    shape=21,size=2.0,colour="black",stroke=0.4)+scale_fill_manual(
      values=c("Floating"="#CAE1FF","Decanted"="#8B7B8B"))+
  scale_y_continuous(expand=expansion(mult=c(0.02,0.08)))+
  labs(x="Trophic level",y="Number of putative microplastic particles",
    fill = "Fraction")+figure_theme
ggsave(file.path(figures_dir,"Figure_1_particle_counts.tiff"),
  g_box,width=7,height=5.5,units="in",dpi=600,compression="lzw")

# 9. PUBLICATION TABLES
table_1<-descriptive%>%select(Level,n,Floating_Median_IQR,Decanted_Median_IQR)
table_2<-kw_table
table_3<-dunn_floating_table

# 10. EXPORT TABLES
write.xlsx(list(Descriptive=table_1,Kruskal_Wallis=table_2,Dunn_Floating = table_3),
  file.path(tables_dir,"Microplastics_publication_tables.xlsx"),overwrite=TRUE)
write.csv(table_1,file.path(tables_dir,"Table_1_Descriptive.csv"),row.names=FALSE)
write.csv(table_2,file.path(tables_dir,"Table_2_Kruskal_Wallis.csv"),row.names=FALSE)
write.csv(table_3,file.path(tables_dir,"Table_3_Dunn_Floating.csv"),row.names=FALSE)

# 11. FINAL RESULTS
cat("\nAnalysis completed successfully.\n")
cat("Figures saved to:", figures_dir, "\n")
cat("Tables saved to:", tables_dir, "\n\n")
cat("Kruskal-Wallis — Floating:\n")
print(kw_floating)
cat("\nKruskal-Wallis — Decanted:\n")
print(kw_decanted)