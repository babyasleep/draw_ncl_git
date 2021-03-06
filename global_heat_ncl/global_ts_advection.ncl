begin
;case_name="HEAT_MC"
  gridType  = 1   ; global gaussian grid
  opt_adv   = 0   ; return only the advected variable       
  long_name = "advection of temperature"
  units     = "K/s"
  ;outfile="/home/ys17-19/cjx/figure/heat_test_figure/global_wind_"+level(i)+"_ttest"
  outfile="/home/ys17-19/cjx/figure/"+case_name+"_figure/"+season+" global_surface_temperature_advection"
  ;HEAT_file="/home/ys17-19/cjx/all_output_data/HEAT_MC_output/HEAT_MC.cam.h0.250-289.nc"
  HEAT_file="/home/ys17-19/cjx/all_output_data/"+case_name+"_output/"+case_name+".cam.h0.250-289.nc"
  ;CTRL_file="/home/ys17-19/cjx/all_output_data/B2000_CTRL_output/B2000_f19g16_CP_CTRL.cam.h0.250-289.nc"
  fin_heat = addfile(HEAT_file,"r")
  fin_ctrl = addfile(CTRL_file,"r")

  u_ctrl = fin_ctrl->U(120:479:1,:,:)      
  v_ctrl = fin_ctrl->V(120:479:1,:,:)
  t_ctrl = fin_ctrl->T(120:479:1,:,:)
  u_heat = fin_heat->U(120:479:1,:,:)   
  v_heat = fin_heat->V(120:479:1,:,:)
  t_heat = fin_heat->T(120:479:1,:,:)   

  lat    = fin_heat->lat
  lon    = fin_heat->lon

  v_heat_ssn = month_to_season(v_heat,season)
  u_heat_ssn = month_to_season(u_heat,season)
  v_ctrl_ssn = month_to_season(v_ctrl,season)
  u_ctrl_ssn = month_to_season(u_ctrl,season)
  t_heat_ssn = month_to_season(t_heat,season)
  t_ctrl_ssn = month_to_season(t_ctrl,season)
  u_in= dim_avg_n_Wrap(u_heat_ssn - u_ctrl_ssn,0)
  v_in= dim_avg_n_Wrap(v_heat_ssn - v_ctrl_ssn,0)
  t_in= dim_avg_n_Wrap(t_heat_ssn - t_ctrl_ssn,0)
  

  Temp_adv = u_in*center_finite_diff_n(t_in,lat,False,0,0)+v_in*center_finite_diff_n(t_in,lon,False,0,1)
  ;;Temp_adv = advect_variable(u_in,v_in,vr,gridType,long_name,units,opt_adv)
  printVarSummary(Temp_adv)  
  printMinMax(Temp_adv, 0)  
  copy_VarCoords(t_heat(0,:,:),Temp_adv)
  ;plot1 = new(1,"graphic")
  ;plot2 = new(1,"graphic")
   
  wks = gsn_open_wks("eps",outfile)     
  gsn_define_colormap(wks,"BlueWhiteOrangeRed")
   
  res                 = True  
  res@gsnDraw         = False
  res@gsnFrame        = False
  res@tmXBTickSpacingF =60
  res@tmYLTickSpacingF =30
  res@pmLabelBarOrthogonalPosF = 0.15
  res@lbLabelFontHeightF = g_font
  res@mpCenterLonF = 180.
  res@gsnAddCyclic = True
  ;res@cnLineLabelsOn   = False      ; turn off contour line labels
  res@gsnMaximize      = True       ; fill up the page
  res@gsnLeftString   = " "                   
  res@gsnRightString  = " "                 
  res@gsnCenterString = season+" Temperature Advection"+level(i)+" Diff"
  res@gsnAddCyclic    =True
  res@cnLevelSelectionMode  = "ManualLevels" ; set manual contour levels
  res@cnFillColors =(/ 58, 74, 90, 96, 144, 170, 186, 202/)
  res@cnMinLevelValF        = -3e-2         ; set min contour level
  res@cnMaxLevelValF        =  3e-2         ; set max contour level
  res@cnLevelSpacingF       =  1e-2          ; set contour interval
  res@cnFillOn      = True                  
  res@cnLinesOn     = False                 
;  res@gsnCenterStringFontHeightF = g_font  
  res@tiMainOn               = False
  res@mpFillOn               = False
  res@mpGeophysicalLineThicknessF = l_thick
  res@mpGridLineThicknessF   = l_thick
  res@tmXBLabelFontHeightF = g_font
  res@tmYLLabelFontHeightF = g_font
  res@mpMaxLatF=lat_N
  res@mpMinLatF=lat_S
  res@mpMaxLonF=lon_W
  res@mpMinLonF=lon_E

  ;plot1 = gsn_csm_vector_map(wks,u,v,res)
  ;plot2 = gsn_csm_vector(wks,u_diff_sig,v_diff_sig,res4)
  plot1  = gsn_csm_contour_map(wks,Temp_adv,res)
  polyres                   = True
  polyres@gsMarkerIndex     = 10          ; polymarker style
  polyres@gsMarkerSizeF     = 16.          ; polymarker size
  polyres@gsMarkerThicknessF     = 6.          ; polymarker size
  polyres@gsMarkerColor     = "green"          ; polymarker size
  plot1@$unique_string("fxxk ncl")$    = gsn_add_polymarker(wks,plot1,lon_array(j),lat_array(j),polyres)
  ;overlay(plot1,plot2)
  draw(plot1)
  frame(wks)
  end do
;delete(res)
;delete(res4)
delete(level)
;delete(case_name)
end
