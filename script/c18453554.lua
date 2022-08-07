--쇼팽 에튀드 10-8 햇빛
local s,id=GetID()
function s.initial_effect(c)
	local e1=MakeEff(c,"S")
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetCondition(s.con1)
	c:RegisterEffect(e1)
	local e2=MakeEff(c,"A")
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetCL(1,id,EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e2)
	local e3=MakeEff(c,"Qo","S")
	e3:SetCode(EVENT_CHAINING)
	e3:SetCategory(CATEGORY_DRAW)
	e3:SetD(id,0)
	e3:SetCL(1)
	WriteEff(e3,3,"NCTO")
	c:RegisterEffect(e3)
	local e4=MakeEff(c,"Qo","S")
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCategory(CATEGORY_FUSION_SUMMON+CATEGORY_SPECIAL_SUMMON)
	e4:SetD(id,1)
	e4:SetCL(1,{id,1})
	WriteEff(e4,4,"TO")
	c:RegisterEffect(e4)
end
function s.con1(e)
	local c=e:GetHandler()
	return c:IsPublic()
end
function s.con3(e,tp,eg,ep,ev,re,r,rp)
	return rp~=tp
end
function s.cfil3(c)
	return c:IsSetCard(0x2f3) and c:IsAbleToGraveAsCost() and (c:IsFaceup() or c:IsLoc("H"))
end
function s.cost3(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local exc=c:IsStatus(STATUS_CHAINING) and c or nil
	if chk==0 then
		return Duel.IEMCard(s.cfil3,tp,"HO",0,1,c)
	end
	Duel.Hint(HINT_SELEECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SMCard(tp,s.cfil3,tp,"HO",0,1,1,c)
	Duel.SendtoGrave(g,REASON_COST)
	local tc=g:GetFirst()
	if tc==c then
		e:SetLabel(1)
	else
		e:SetLabel(0)
	end
end
function s.tar3(e,tp,eg,ep,ev,re,r,rp,chk)
	local con=re:GetCondition()
	local tg=re:GetTarget()
	Auxiliary.ChopinEtudeSetCode=0x2f3
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	res=(not con or con(e,tp,teg,tep,tev,tre,tr,trp)) and (not tg or tg(e,tp,teg,tep,tev,tre,tr,trp,0))
	Auxiliary.ChopinEtudeSetCode=nil
	if chk==0 then
		e:SetProperty(0)
		return res
	end
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	Auxiliary.ChopinEtudeSetCode=0x2f3
	e:SetProperty(re:GetProperty())
	if tg then
		tg(e,tp,teg,tep,tev,tre,tr,trp,1)
	end
	Duel.ClearOperationInfo(0)
	Auxiliary.ChopinEtudeSetCode=nil
	Duel.SPOI(0,CATEGORY_DRAW,nil,0,tp,1)
end
function s.op3(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetLabel()==0 and not c:IsRelateToEffect(e) then
		return
	end
	local ct=Duel.GetTurnCount()
	if not Duel.FractionDraw(tp,{ct,3},REASON_EFFECT) then
		return
	end
	Duel.BreakEffect()
	local res,teg,tep,tev,tre,tr,trp
	if re:GetCode()==EVENT_CHAINING then
		local chain=Duel.GetCurrentChain()
		local ce=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_EFFECT)
		local cc=ce:GetHandler()
		local cg=Group.FromCards(cc)
		local cp=Duel.GetChainInfo(chain,CHAININFO_TRIGGERING_PLAYER)
		teg,tep,tev,tre,tr,trp=cg,cp,chain,ce,REASON_EFFECT,cp
	elseif re:GetCode()==EVENT_FREE_CHAIN then
		teg,tep,tev,tre,tr,trp=eg,ep,ev,re,r,rp
	else
		res,teg,tep,tev,tre,tr,trp=Duel.CheckEvent(re:GetCode(),true)
	end
	local op=re:GetOperation()
	if op then
		Auxiliary.ChopinEtudeSetCode=0x2f3
		op(e,tp,teg,tep,tev,tre,tr,trp)
		Auxiliary.ChopinEtudeSetCode=nil
	end
end
function s.tfil4(c,e,tp,m1,m2,f,tc,chkf)
	local mg=m1
	if c.december_fmaterial then
		mg:Merge(m2)
	end
	return c:IsType(TYPE_FUSION) and c:IsSetCard(0x2f3) and (not f or f(c)) and c.december_fmaterial
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(mg,tc,chkf)
end
function s.tar4(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		local chkf=tp
		local mg1=Duel.GetFusionMaterial(tp)
		local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP)
		local res=Duel.IsExistingMatchingCard(s.tfil4,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg1,mg2,nil,c,chkf)
		if not res then
			local ce=Duel.GetChainMaterial(tp)
			if ce~=nil then
				local fgroup=ce:GetTarget()
				local mg3=fgroup(ce,e,tp)
				local mf=ce:GetValue()
				res=Duel.IsExistingMatchingCard(s.tfil4,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg3,Group.CreateGroup(),mf,nil,chkf)
			end
		end
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function s.ofil4(c,e)
	return not c:IsImmuneToEffect(e)
end
function s.op4(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then
		return
	end
	local chkf=tp
	local mg1=Duel.GetFusionMaterial(tp):Filter(s.ofil4,nil,e)
	local mg2=Duel.GetMatchingGroup(Card.IsType,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,TYPE_SPELL+TYPE_TRAP):Filter(s.ofil4,nil,e)
	local sg1=Duel.GetMatchingGroup(s.tfil4,tp,LOCATION_EXTRA,0,nil,e,tp,mg1,mg2,nil,c,chkf)
	local mg3=nil
	local sg2=nil
	if ce~=nil then
		local fgroup=ce:GetTarget()
		mg3=fgroup(ce,e,tp)
		local mf=ce:GetValue()
		sg2=Duel.GetMatchingGroup(s.tfil4,tp,LOCATION_EXTRA,0,nil,e,tp,mg3,Group.CreateGroup(),mf,nil,chkf)
	end
	if sg1:GetCount()>0 or (sg2~=nil and sg2:GetCount()>0) then
		local sg=sg1:Clone()
		if sg2 then
			sg:Merge(sg2)
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		if sg1:IsContains(tc) and (sg2==nil or not sg2:IsContains(tc) or not Duel.SelectYesNo(tp,ce:GetDescription())) then
			if tc.december_fmaterial then
				mg1:Merge(mg2)
			end
			local mat1=Duel.SelectFusionMaterial(tp,tc,mg1,c,chkf)
			tc:SetMaterial(mat1)
			Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		else
			local mat2=Duel.SelectFusionMaterial(tp,tc,mg3,nil,chkf)
			local fop=ce:GetOperation()
			fop(ce,e,tp,tc,mat2)
		end
		tc:CompleteProcedure()
	end
end