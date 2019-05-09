package package1

import (
	"fmt"
	"net/http"
)

type SampleHandler struct {
	sampleDBRef string
}

func NewSampleHandler(sampleDBRef string) *SampleHandler {
	return &SampleHandler{sampleDBRef: sampleDBRef}
}

func (s *SampleHandler) HelloHandler(w http.ResponseWriter, r *http.Request) {
	fmt.Fprintf(w, "Hello, World")
}
