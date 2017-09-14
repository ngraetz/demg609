---
  output:
  pdf_document:
  highlight: tango
fig_caption: true
header-includes:
  - \setlength\parindent{24pt}
- \setlength{\parskip}{1em}
- \usepackage{amsmath}
geometry: margin=1in
fontsize: 11pt
bibliography: "C:/Users/ngraetz/Documents/Bibtex/maternal_education_thesis.bib"
csl: the-lancet.csl
---
  
```{r setup, echo=FALSE}
library(knitr)
knit_hooks$set(small.mar = function(before, options, envir) {
  if (before)    par(mar=c(1,1,1,1)+.1)  # smaller margin on top and right
})
opts_chunk$set(small.mar=TRUE)
```

\thispagestyle{empty}
```{r child = 'Title Page.Rmd'}
```

\newpage
\thispagestyle{empty}

```{r child = 'Copyright.Rmd'}
```

\newpage
\thispagestyle{empty}

```{r child = 'Abstract.Rmd'}
```

\newpage
\setlength{\parindent}{4em}

# I. Introduction

With recent research suggesting that increases in maternal education are associated with huge decreases in child mortality at the national level, international agendas have increasingly focused on education as a powerful social determinant of child and maternal health outcomes.[@Gakidou2010][@UNESCO2015][@UnitedNations2016] A recent UNICEF report noted that across much of South Asia and sub-Saharan Africa, children born to mothers with no education are almost three times more likely to die before they are five than those born to mothers with a secondary education.[@UNICEF2014] However, the demonstrated relationship between level of education and child mortality is variable by country, and there is concern that large gains in national averages have not been equitably distributed.[@Nnebe2014][@Mwesigwa2015][@UNICEF2014] Empirical and anecdotal evidence suggests that increases in the national average for an indicator could be entirely driven by gains in a specific population or a specific region of the country.[@Campbell2011][@Mwesigwa2015][@UNICEF2014] As national average progress in increasing education is correlated with national average progress in reducing child mortality (and other health outcomes), this has a large implication on how programs to improve educational attainment are evaluated. Looking at national data, countries may have achieved national MDG targets over the last period of international agenda-setting but certain subnational regions may have stagnated or deteriorated over the same period. In an effort to target intervention efforts more effectively at the local level and avoid entrenching subnational inequities, it's becoming increasingly important to understand the geographic distribution of education and progress achieved. The language surrounding equity is evident in the new Sustainable Development Goals (SDGs), adopted last year by 193 UN Member States. These goals aim by 2030 to eradicate poverty and ensure inclusive and equitable quality education and promote lifelong learning opportunities for all.[@UnitedNations2016] In their Education for All 2030 initiative, UNESCO refocuses on an agenda for reforming education access in developing countries centered around equity.[@UNESCO2015] However, comparable indicators for education across space and time only exist at the national aggregate level, making it difficult to interrogate equity in progress toward these targets.\par

In considering subnational inequality, it is important to mark the distinction between examining the distribution of people versus the spatial distribution averages over an area. In an ideal model with complete data, there would be no distinction - we would be modeling every individual in space and time, and could explore their distribution of values (inequality) or the spatial clustering of values (segregation). This is obviously not feasible given real-world data coverage, so household survey data like the Demographic Health Survey (DHS) are usually aggregated in accordance with the sample design to produce an unbiased estimate of a population statistic, i.e. national average years of education. However, rather than only focusing on the national mean you could focus on a statistic that describes the distribution of people in that country, like the standard deviation or the Gini coefficient, a traditional metric for characterizing inequality in a representative sample of incomes. In examining a distributional statistic over time, you could explore whether the mean has been increasing over time while the spread has also been increasing; the initially well-off population is progressing quickly while the initially disadvantaged population is stagnating or getting worse.\par

This would answer an important question, and more research is certainly required to explore whether national distribution characteristics of education are more predictive for health outcomes than national means. Alternatively, little research has been done that fully leverages the increasingly comprehensive spatial information in more recent cycles of DHS and other household survey data, particularly for modeling social exposures.[@Gething2015] Modeling average education indicators at a much finer resolution than national could provide valuable insight into the question of educational inequality and the spatial clustering of progress. There should also be strong consideration paid to how policy is being enacted - over specific populations or over specific geographic areas.\par

New methods for high-resolution geospatial modeling offer an exciting and efficient new avenue for estimating a surface of educational attainment using geolocated DHS clusters. Bayesian model-based geostatistics (MBG), recently pioneered largely in the field of parasitology to explore distributions of malaria indicators and other infectious diseases, allow efficient and robust estimation of the spatial structure of data that is precisely located in space, i.e. latitude and longitude.[@Pigott2015][@Patil2011][@Hay2013] The DHS Spatial Analysis Reports have called for more research applying these types of methods to the new abundance of geolocated cluster data.\par 

The goal of the current study is to explore how national education levels and trends in several African countries have been distributed subnationally over time, and how that distribution varies by country. This will be a novel application of very recently developed and evolving methods for leveraging the spatial information in geolocated DHS clusters. Being able to formalize and visualize a predictive model will provide useful insights on measuring equity in maternal and child health progress as they relate to international goals, and will allow exploration of whether or not all national average progress is occurring in populous urban centers as well as informing more targeted intervention efforts across space. This analysis also has implications for future large-scale descriptive analyses of health outcomes, such as the Global Burden of Disease. As estimates of disease burden become more granular and given that the strong relationship between average education and health outcomes holds at more local levels, it will be important to have a robust, high-resolution suite of social covariates to inform out-of-sample mortality and disease prediction.\par


# II. Data

Data used in this analysis came from the Demographic Health Survey (DHS) for three countries: Nigeria, Uganda, and Kenya. These were chosen as pilot countries for this analysis because each had three DHS with geolocated clusters defining at least a 10-year range. This will allow for a reasonable assessment of progress over time, and the years are equally spaced over the period allowing us to reasonably define the temporal component of our model. At each cluster we were interested in two indicators: mean years of education and proportion of women with 0 years of education. For the sake of comparability between countries and over time, all education data were mapped to standard single-years of education using the UNESCO standards.[@UNESCO2016] Both indicators were estimated as the averages for all women between ages 15 and 54, treating the cluster as a simple random sample in space and time for the 5x5 km grid cell that the cluster latitude/longitude fell within.\par

```{r echo=F,results='asis',error=F,warning=F}
library(knitr)
library(data.table)
table_1 <- fread("C:/Users/ngraetz/Documents/THESIS/final_rmd/tables/table_1.csv")
kable(table_1, format = "markdown", caption = "Table 1. Number of geolocated clusters for each country/period.")
```