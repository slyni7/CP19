--하늘의 마방진
local s,id=GetID()
function s.initial_effect(c)
	local e1=Fusion.CreateSummonEff(c,aux.FilterBoolFunction(Card.IsSetCard,"마방"),nil,nil,s.exop1)
	c:RegisterEffect(e1)
end
function s.exofil11(c,tp)
	return c:IsControler(tp) and c:IsLoc("M") and c:IsFaceup() and c:IsSetCard("마방") and #c:GetSquareMana()>0
end
function s.exofil12(c)
	local st=c:GetSquareMana()
	return #st>0
end
function s.exop1(e,tc,tp,sg)
	if tc:IsCustomType(CUSTOMTYPE_SQUARE) and tc:IsCode(18453676) then
		local mg=sg:Filter(s.exofil11,nil,tp)
		local hg=sg:Clone()
		hg:Sub(mg)
		local hct=0
		local hc=hg:GetFirst()
		while hc do
			hct=hct+math.max(hc:GetLevel(),#hc:GetSquareMana())
			hc=hg:GetNext()
		end
		local mct=0
		local mc=mg:GetFirst()
		while mc do
			mct=mct+math.max(mc:GetLevel(),#mc:GetSquareMana())
			mc=mg:GetNext()
		end
		local rg=mg:Clone()
		if hct+mct>tc:GetLevel() then
			local rct=hct+mct-tc:GetLevel()
			while rct>0 do
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
				local sg=mg:FilterSelect(tp,s.exofil12,0,1,nil)
				local fc=sg:GetFirst()
				if not fc then
					break
				end
				rg:RemoveCard(fc)
				local tst=fc:GetSquareMana()
				local tmg=Group.CreateGroup()
				for i=1,#tst do
					local token=Duel.CreateToken(tp,127800000+tst[i])
					tmg:AddCard(token)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
				local max=math.min(rct,#tmg)
				local trg=tmg:Select(tp,1,max,nil)
				local trt={}
				local trc=trg:GetFirst()
				while trc do
					local tatt=trc:GetCode()-127800000
					table.insert(trt,tatt)
					trc=trg:GetNext()
				end
				local e1=MakeEff(e:GetHandler(),"S")
				e1:SetCode(EFFECT_SQUARE_MANA_DECLINE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				e1:SetValue(function(_,_)
					return table.unpack(trt)
				end)
				fc:RegisterEffect(e1)
				if #fc:GetSquareMana()==0 then
					rg:AddCard(fc)
				end
				rct=rct-#trt
			end
		end
		hg:Merge(rg)
		Duel.SendtoGrave(hg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	else
		Duel.SendtoGrave(sg,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
	end
	sg:Clear()
end